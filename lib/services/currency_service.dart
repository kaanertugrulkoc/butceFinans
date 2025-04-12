import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart';

class CurrencyService {
  static const String _tcmbUrl = 'https://www.tcmb.gov.tr/kurlar/today.xml';

  Future<Map<String, dynamic>> getCurrencyRates() async {
    try {
      final response = await http.get(Uri.parse(_tcmbUrl));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        // USD kuru
        final usdElement = document
            .findAllElements('Currency')
            .firstWhere((element) => element.getAttribute('Kod') == 'USD');
        final usdRate = double.parse(usdElement
            .findElements('ForexSelling')
            .first
            .text
            .replaceAll(',', '.'));

        // EUR kuru
        final eurElement = document
            .findAllElements('Currency')
            .firstWhere((element) => element.getAttribute('Kod') == 'EUR');
        final eurRate = double.parse(eurElement
            .findElements('ForexSelling')
            .first
            .text
            .replaceAll(',', '.'));

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
      final response = await http.get(Uri.parse(_tcmbUrl));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);

        // Gram altın fiyatı
        final goldElement = document
            .findAllElements('Currency')
            .firstWhere((element) => element.getAttribute('Kod') == 'XAU');
        final goldRate = double.parse(goldElement
            .findElements('ForexSelling')
            .first
            .text
            .replaceAll(',', '.'));

        return goldRate;
      }
      throw Exception('Altın fiyatı alınamadı');
    } catch (e) {
      // TCMB API hatası durumunda yedek API'yi dene
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
