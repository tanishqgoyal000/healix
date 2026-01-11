import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/storage_service.dart';
import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    medicines = await StorageService.getMedicines();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicine Expiry Tracker')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanScreen()),
          );
          load();
        },
      ),
      body: medicines.isEmpty
          ? const Center(child: Text('No medicines added'))
          : ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (_, i) {
          final m = medicines[i];
          return ListTile(
            title: Text(m.name),
            subtitle: Text('EXP: ${m.expiry}'),
          );
        },
      ),
    );
  }
}
