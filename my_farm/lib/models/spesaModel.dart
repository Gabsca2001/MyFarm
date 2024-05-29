import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Spesa {
  final String name;
  final String store;
  final String description;
  final double price;
  final DateTime date;

  Spesa({
    required this.name,
    required this.store,
    required this.description,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'store': store,
      'description': description,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  // Create an Activity object from JSON string
  factory Spesa.fromJson(Map<String, dynamic> json) {
    return Spesa(
      name: json['name'] as String,
      store: json['store'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      date: DateTime.parse(json['date']),
    );
  }
}

//store spese
Future<void> storeSpese(List<Spesa> spese) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> speseJsonList = spese.map((spesa) => jsonEncode(spesa.toJson())).toList();
  await prefs.setStringList('spese', speseJsonList);
}

Future<List<Spesa>> getSpese() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? speseJsonList = prefs.getStringList('spese');
  if (speseJsonList == null) return [];
  return speseJsonList.map((spesaJson) => Spesa.fromJson(jsonDecode(spesaJson))).toList();
}

//List of stores
List<String> stores = ['VerdeIn', 'Claudio', 'AcquaDrip'];

//store stores
Future<void> storeStores(List<String> stores) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('stores', stores);
}

Future<List<String>> getStores() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? stores = prefs.getStringList('stores');
  if (stores == null){
    stores = ['VerdeIn', 'Claudio', 'AcquaDrip'];
    await storeStores(stores);
  }
  return stores;
}
