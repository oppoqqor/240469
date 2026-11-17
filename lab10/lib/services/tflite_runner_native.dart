import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteRunner {
  TfliteRunner._(this._interpreter);

  final Interpreter _interpreter;

  static Future<TfliteRunner> fromAsset(String assetPath) async {
    final interpreter = await Interpreter.fromAsset(assetPath);
    return TfliteRunner._(interpreter);
  }

  void run(List<List<List<List<double>>>> input, List<List<double>> output) {
    _interpreter.run(input, output);
  }

  void close() {
    _interpreter.close();
  }
}
