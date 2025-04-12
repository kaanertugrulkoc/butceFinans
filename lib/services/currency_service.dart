import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  static const String _dovizUrl =
      'https://api.doviz.com/api/v1/currencies/all/latest';

  Future<Map<String, dynamic>> getCurrencyRates() async {
    try {
      final response = await http.get(Uri.parse(_dovizUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // USD kuru
        final usdData = data.firstWhere((item) => item['code'] == 'USD');
        final usdRate = double.parse(usdData['selling'].toString());

        // EUR kuru
        final eurData = data.firstWhere((item) => item['code'] == 'EUR');
        final eurRate = double.parse(eurData['selling'].toString());

        return {
          'usd': usdRate,
          'eur': eurRate,
        };
      }
      throw Exception('Döviz kurları alınamadı');
    } catch (e) {
      throw Exception('Döviz kurları yüklenirken hata oluştu: $e');
    }
  }

  Future<double> getGoldPrice() async {
    try {
      final response = await http.get(Uri.parse(_dovizUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Gram altın fiyatı
        final goldData = data.firstWhere((item) => item['code'] == 'GOLD');
        final goldRate = double.parse(goldData['selling'].toString());

        return goldRate;
      }
      throw Exception('Altın fiyatı alınamadı');
    } catch (e) {
      // Doviz.com API hatası durumunda yedek API'yi dene
      return _getBackupGoldPrice();
    }
  }

  Future<double> _getBackupGoldPrice() async {
    try {
      // Yedek API: Döviz kurları API'sinden USD/TRY kurunu al
      final response = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final usdToTry = data['rates']['TRY'];
        // Yaklaşık gram altın fiyatı (USD cinsinden)
        const approximateGoldPricePerGram = 60.0;
        return approximateGoldPricePerGram * usdToTry;
      }
      throw Exception('Yedek API\'den altın fiyatı alınamadı');
    } catch (e) {
      throw Exception('Altın fiyatı yüklenirken hata oluştu: $e');
    }
  }
}
