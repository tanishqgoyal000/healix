import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';

class StorageService {
  static const key = 'medicines';

  static Future<void> saveMedicine(Medicine m) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getMedicines();
    list.add(m);
    prefs.setString(
      key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<List<Medicine>> getMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => Medicine.fromJson(e))
        .toList();
  }
}
