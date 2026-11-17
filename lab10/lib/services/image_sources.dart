import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageSources {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> fromCamera() async {
    final shot = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024);
    return shot == null ? null : await shot.readAsBytes();
  }

  Future<Uint8List?> fromGallery() async {
    final shot = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
    return shot == null ? null : await shot.readAsBytes();
  }

  Future<Uint8List> fromUrl(String url) async {
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https') || uri.host.isEmpty) {
      throw const FormatException('Enter a valid http or https image URL.');
    }
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const FormatException('Request timed out while downloading image.');
    } catch (_) {
      throw const FormatException('Network error while downloading image.');
    }
    if (response.statusCode != 200) {
      throw FormatException('Server returned status ${response.statusCode}.');
    }
    final contentType = (response.headers['content-type'] ?? '').toLowerCase();
    if (!contentType.startsWith('image/')) {
      throw const FormatException('URL did not return an image.');
    }
    return response.bodyBytes;
  }
}
