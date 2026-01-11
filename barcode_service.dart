import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class BarcodeService {
  static final BarcodeScanner _scanner = BarcodeScanner(
    formats: [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.upca,
    ],
  );

  /// Scan barcode or QR from an image file
  static Future<String?> scanFromFile(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final barcodes = await _scanner.processImage(inputImage);

      if (barcodes.isEmpty) return null;
      return barcodes.first.rawValue;
    } catch (e) {
      print('Barcode ls libscan error: $e');
      return null;
    }
  }

  static void dispose() {
    _scanner.close();
  }
}
