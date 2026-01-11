import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class LiveOcrService {
  final TextRecognizer _textRecognizer =
  TextRecognizer(script: TextRecognitionScript.latin);

  /// Perform OCR on an image file (camera capture or frame)
  Future<String> recognizeTextFromFile(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText =
      await _textRecognizer.processImage(inputImage);

      return recognizedText.text;
    } catch (e) {
      print("Live OCR error: $e");
      return '';
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
