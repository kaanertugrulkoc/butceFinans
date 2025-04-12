import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  static const String _exchangeRateUrl =
      'https://api.exchangerate-api.com/v4/latest/USD';
  static const String _goldPriceUrl =
      'https://data-asg.goldprice.org/dbXRates/TRY';

  Future<Map<String, dynamic>> getCurrencyRates() async {
    try {
      final response = await http.get(Uri.parse(_exchangeRateUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'];

        // USD/TRY kuru
        final usdRate = rates['TRY'];

        // EUR/TRY kuru (USD/TRY * USD/EUR)
        final eurRate = rates['TRY'] / rates['EUR'];

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
      final response = await http.get(Uri.parse(_goldPriceUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Goldprice.org'dan gram altın fiyatını al
        final goldPrice =
            data['items'][0]['xauPrice'] / 31.1034768; // Ons'tan gram'a çevir
        return goldPrice;
      }
      throw Exception('Altın fiyatı alınamadı');
    } catch (e) {
      // Goldprice.org API hatası durumunda yedek API'yi dene
      return _getBackupGoldPrice();
    }
  }

  Future<double> _getBackupGoldPrice() async {
    try {
      // Yedek API: Döviz kurları API'sinden USD/TRY kurunu al
      final response = await http.get(Uri.parse(_exchangeRateUrl));
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
