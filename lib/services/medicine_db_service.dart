import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicineDbService {
  /// Online lookup (OpenFDA / OpenFoodFacts style)
  static Future<String?> lookupOnline(String barcode) async {
    try {
      final url =
      Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');

      final res = await http.get(url);
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      return data['product']?['product_name'];
    } catch (_) {
      return null;
    }
  }

  /// Offline fallback (expandable)
  static String? lookupOffline(String barcode) {
    const localDb = {
      '8901234567890': 'Paracetamol',
      '8909876543210': 'Amoxicillin',
    };

    return localDb[barcode];
  }

  static Future<String> resolveMedicineName(String barcode) async {
    return await lookupOnline(barcode) ??
        lookupOffline(barcode) ??
        'Unknown Medicine';
  }
}
