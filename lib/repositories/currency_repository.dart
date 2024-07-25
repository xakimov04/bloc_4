import 'dart:convert';
import 'package:flutter_application_1/models/currency.dart';
import 'package:http/http.dart' as http;

class CurrencyRepository {
  Future<List<Currency>> fetchCurrencies() async {
    final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;
      return rates.entries.map((e) => Currency(name: e.key, rate: e.value.toDouble())).toList();
    } else {
      throw Exception('Failed to load currencies');
    }
  }
}
