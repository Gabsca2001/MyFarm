import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity {
  final String name;
  final String type;
  final String? description;
  final DateTime date;
  final TimeOfDay? time;
  final List<String>? workers;

  Activity({
    required this.name,
    required this.type,
    this.description,
    required this.date,
    this.time,
    this.workers,
  });

  get id => null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
      'time': '${time?.hour}:${time?.minute}',
      'workers': workers,
    };
  }

  // Create an Activity object from JSON string
  factory Activity.fromJson(Map<String, dynamic> json) {
    List<String> workersFromJson = List<String>.from(json['workers']);
    List<String> timeParts = json['time'].split(':');
    return Activity(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      workers: workersFromJson as List<String>?,
    );
  }
  
}

Future<void> storeActivities(List<Activity> activities) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> activityJsonList = activities.map((activity) => jsonEncode(activity.toJson())).toList();
  await prefs.setStringList('activities', activityJsonList);
}

Future<List<Activity>> getActivities() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? activityJsonList = prefs.getStringList('activities');
  if (activityJsonList == null) return [];
  return activityJsonList.map((activityJson) => Activity.fromJson(jsonDecode(activityJson))).toList();
}

/*Activity types */
List<String> activityTypes = ['Irrigazione', 'Fertilizzazione', 'Trattamento fitosanitario', 'Lavoro manuale', 'Altro'];

void addActivityType(String activityType) {
  activityTypes.add(activityType);
}

List<String> getActivityTypes() {
  return activityTypes;
}




/*Workers */
List<String> workers = ['Andrea', 'Gabriele', 'Giuseppe Lo Duca', 'Kevin'];

Future<void> storeWorkers(List<String> workers) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('workers', workers);
}

Future<List<String>> getWorkers() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? workers = prefs.getStringList('workers');
  if (workers == null) {
    // Se non ci sono lavoratori memorizzati, inizializziamo con la lista di prova
    workers = ['Andrea', 'Gabriele', 'Giuseppe Lo Duca', 'Kevin'];
    await storeWorkers(workers);
  }
  return workers;
}

