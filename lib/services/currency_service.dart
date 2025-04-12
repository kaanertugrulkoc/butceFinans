import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  static const String _baseUrl =
      'https://api.exchangerate-api.com/v4/latest/TRY';
  static const String _goldApiUrl = 'https://api.metals.live/v1/spot/gold';

  Future<Map<String, dynamic>> getCurrencyRates() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'usd': 1 / data['rates']['USD'],
          'eur': 1 / data['rates']['EUR'],
        };
      }
      throw Exception('Failed to load currency rates');
    } catch (e) {
      throw Exception('Error fetching currency rates: $e');
    }
  }

  Future<double> getGoldPrice() async {
    try {
      final response = await http.get(Uri.parse(_goldApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['price'] / 31.1035; // Convert to gram
      }
      throw Exception('Failed to load gold price');
    } catch (e) {
      throw Exception('Error fetching gold price: $e');
    }
  }
}
