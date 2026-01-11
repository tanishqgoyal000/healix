import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../services/live_ocr_service.dart';
import '../utils/expiry_parser.dart';
import '../services/storage_service.dart';
import '../models/medicine.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  bool _isScanning = false;

  final LiveOcrService _liveOcrService = LiveOcrService();
  Timer? _manualTimer;

  @override
  void initState() {
    super.initState();
    _initCamera();

    // Manual entry after 30 seconds if nothing detected
    _manualTimer = Timer(const Duration(seconds: 30), _showManualEntry);
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _scanOnce() async {
    if (_isScanning || _controller == null) return;
    _isScanning = true;

    try {
      // 1️⃣ Capture image
      final XFile xFile = await _controller!.takePicture();
      final File imageFile = File(xFile.path);

      // 2️⃣ OCR
      final String text =
      await _liveOcrService.recognizeTextFromFile(imageFile);

      // 3️⃣ Parse expiry
      final String? expiry = ExpiryParser.extract(text);

      if (expiry != null) {
        await StorageService.saveMedicine(
          Medicine(
            name: 'Scanned Medicine',
            expiry: expiry,
          ),
        );

        if (mounted) Navigator.pop(context);
      } else {
        _showManualEntry();
      }
    } catch (e) {
      debugPrint('Scan error: $e');
      _showManualEntry();
    } finally {
      _isScanning = false;
    }
  }

  void _showManualEntry() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        final expiryController = TextEditingController();

        return AlertDialog(
          title: const Text('Manual Entry'),
          content: TextField(
            controller: expiryController,
            decoration:
            const InputDecoration(labelText: 'Expiry (e.g. 08/2026)'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (expiryController.text.isNotEmpty) {
                  await StorageService.saveMedicine(
                    Medicine(
                      name: 'Manual Entry',
                      expiry: expiryController.text,
                    ),
                  );
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _manualTimer?.cancel();
    _liveOcrService.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Expiry')),
      body: Stack(
        children: [
          CameraPreview(_controller!),

          // 🔲 Visual scan box (static for now, safe)
          Center(
            child: Container(
              width: 260,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 3),
              ),
            ),
          ),

          // 📸 Scan button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _scanOnce,
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
