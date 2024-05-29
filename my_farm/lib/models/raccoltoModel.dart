import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Raccolto{
  final String nome;
  final double quantita;
  final DateTime data;
  final String? description;
  final double prezzo;

  Raccolto({
    required this.nome,
    required this.quantita,
    required this.data,
    this.description,
    required this.prezzo,
  });

  Map<String, dynamic> toJson(){
    return {
      'nome': nome,
      'quantita': quantita,
      'data': data.toIso8601String(),
      'description': description,
      'prezzo': prezzo,
    };
  }

  factory Raccolto.fromJson(Map<String, dynamic> json){
    return Raccolto(
      nome: json['nome'] as String,
      quantita: json['quantita'] as double,
      data: DateTime.parse(json['data']),
      description: json['description'] as String?,
      prezzo: json['prezzo'] as double,
    );
  }

}

Future<void> storeRaccolto(List<Raccolto> raccolto) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> raccoltoList = raccolto.map((raccolto) => jsonEncode(raccolto.toJson())).toList();
  await prefs.setStringList('raccolto', raccoltoList);
}

Future<List<Raccolto>> getRaccolti() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? raccoltoList = prefs.getStringList('raccolto');
  if (raccoltoList == null) return [];
  return raccoltoList.map((raccolto) => Raccolto.fromJson(jsonDecode(raccolto))).toList();
}

//clear raccolto
Future<void> clearRaccolto() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('raccolto');
}