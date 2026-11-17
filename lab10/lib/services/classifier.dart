import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'tflite_runner_native.dart' if (dart.library.js_interop) 'tflite_runner_web.dart';

class Prediction {
  const Prediction(this.label, this.confidence);

  final String label;
  final double confidence;
}

class ClassificationRecord {
  const ClassificationRecord({
    required this.bytes,
    required this.predictions,
    required this.source,
    required this.timestamp,
  });

  final Uint8List bytes;
  final List<Prediction> predictions;
  final String source;
  final DateTime timestamp;

  Prediction get top => predictions.first;
}

List<String> parseLabels(String raw) => [
      for (final line in raw.split('\n'))
        if (line.trim().isNotEmpty) line.trim().replaceFirst(RegExp(r'^\d+\s+'), ''),
    ];

class Classifier {
  Classifier._(this._interpreter, this.labels);

  final TfliteRunner _interpreter;
  final List<String> labels;
  static const int inputSize = 224;
  static const String modelAssetPath = 'assets/model/model_unquant.tflite';
  static const String labelsAssetPath = 'assets/model/labels.txt';

  static Future<Classifier> load([String modelPath = modelAssetPath]) async {
    final interpreter = await TfliteRunner.fromAsset(modelPath);
    final labels = parseLabels(await rootBundle.loadString(labelsAssetPath));
    return Classifier._(interpreter, labels);
  }

  List<Prediction> classify(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const FormatException('Not a readable image');
    }
    final square = img.copyResizeCropSquare(img.bakeOrientation(decoded), size: inputSize);
    final input = [
      List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          final p = square.getPixel(x, y);
          return [p.r / 127.5 - 1, p.g / 127.5 - 1, p.b / 127.5 - 1];
        }),
      ),
    ];
    final output = [List<double>.filled(labels.length, 0)];
    _interpreter.run(input, output);
    return [for (var i = 0; i < labels.length; i++) Prediction(labels[i], output.first[i])]
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  void close() => _interpreter.close();
}
