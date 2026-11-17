import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/model_screen.dart';
import 'screens/result_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/classifier.dart';
import 'services/image_sources.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ClassifierApp());

class ClassifierApp extends StatelessWidget {
  const ClassifierApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LabLens Classifier',
        theme: appTheme,
        home: const ClassifierShell(),
      );
}

class ClassifierShell extends StatefulWidget {
  const ClassifierShell({super.key});

  @override
  State<ClassifierShell> createState() => _ClassifierShellState();
}

class _ClassifierShellState extends State<ClassifierShell> {
  final ImageSources _sources = ImageSources();
  final List<ClassificationRecord> _history = [];

  Classifier? _classifier;
  bool _isLoading = true;
  bool _enteredApp = false;
  bool _isDownloading = false;
  String? _loadError;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initClassifier();
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }

  Future<void> _initClassifier() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final classifier = await Classifier.load();
      await _runSmokeTest(classifier);
      if (!mounted) {
        classifier.close();
        return;
      }
      setState(() {
        _classifier = classifier;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError =
            'Could not load ${Classifier.modelAssetPath} or ${Classifier.labelsAssetPath}: $e';
      });
    }
  }

  Future<void> _runSmokeTest(Classifier classifier) async {
    try {
      final data = await rootBundle.load('assets/model/sample.jpg');
      final results = classifier.classify(data.buffer.asUint8List());
      for (final p in results) {
        debugPrint('${p.label}: ${(p.confidence * 100).toStringAsFixed(1)}%');
      }
    } catch (e) {
      debugPrint('Smoke test skipped: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _classifyAndOpen(Uint8List bytes, String source) {
    final classifier = _classifier;
    if (classifier == null) {
      _showError('Model is not loaded yet.');
      return;
    }
    try {
      final watch = Stopwatch()..start();
      final predictions = classifier.classify(bytes);
      watch.stop();
      debugPrint('classify ($source) took ${watch.elapsedMilliseconds} ms');
      final record = ClassificationRecord(
        bytes: bytes,
        predictions: predictions,
        source: source,
        timestamp: DateTime.now(),
      );
      setState(() => _history.insert(0, record));
      _openResult(record);
    } on FormatException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Classification failed: $e');
    }
  }

  void _openResult(ClassificationRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultScreen(record: record)),
    );
  }

  Future<void> _pickCamera() async {
    try {
      final bytes = await _sources.fromCamera();
      if (bytes == null || !mounted) return;
      _classifyAndOpen(bytes, 'Camera');
    } catch (e) {
      _showError('Camera unavailable: $e');
    }
  }

  Future<void> _pickGallery() async {
    try {
      final bytes = await _sources.fromGallery();
      if (bytes == null || !mounted) return;
      _classifyAndOpen(bytes, 'Gallery');
    } catch (e) {
      _showError('Gallery failed: $e');
    }
  }

  Future<void> _downloadUrl(String url) async {
    setState(() => _isDownloading = true);
    try {
      final bytes = await _sources.fromUrl(url);
      if (!mounted) return;
      setState(() => _isDownloading = false);
      _classifyAndOpen(bytes, 'Download');
    } on FormatException catch (e) {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      _showError('Download failed: $e');
    }
  }

  Future<void> _runSample() async {
    try {
      final data = await rootBundle.load('assets/model/sample.jpg');
      if (!mounted) return;
      _classifyAndOpen(data.buffer.asUint8List(), 'Sample');
    } catch (e) {
      _showError('Sample image missing: $e');
    }
  }

  void _testBadBytes() {
    _classifyAndOpen(Uint8List.fromList(utf8.encode('not an image file')), 'Test');
  }

  @override
  Widget build(BuildContext context) {
    if (!_enteredApp) {
      return WelcomeScreen(
        isLoading: _isLoading,
        labels: _classifier?.labels ?? const [],
        loadError: _loadError,
        onGetStarted: () => setState(() => _enteredApp = true),
        onRetry: _initClassifier,
      );
    }

    final titles = ['Home', 'History', 'Model'];
    final pages = [
      HomeScreen(
        latestRecord: _history.isEmpty ? null : _history.first,
        isDownloading: _isDownloading,
        onCamera: _pickCamera,
        onGallery: _pickGallery,
        onDownloadUrl: _downloadUrl,
        onRunSample: _runSample,
        onTestBadBytes: _testBadBytes,
        onOpenResult: _openResult,
      ),
      HistoryScreen(history: _history, onSelect: _openResult),
      ModelScreen(labels: _classifier?.labels ?? const []),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_tabIndex])),
      body: pages[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.memory_outlined), label: 'Model'),
        ],
      ),
    );
  }
}
