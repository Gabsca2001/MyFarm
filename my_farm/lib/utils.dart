// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'models/activityModel.dart';
import 'models/raccoltoModel.dart';
import 'models/spesaModel.dart';


/// Example event class.
class Event {
  final String categoryEvent;
  final String title;
  final String? description;

  Event(this.categoryEvent, this.title, [this.description]);

  @override
  String toString() => title;
}

Map<DateTime, List<Event>> generateEventSource(List<Activity> activities, List<Raccolto> raccolto, List<Spesa> spese) {
  final Map<DateTime, List<Event>> eventSource = {};
  for (final activity in activities) {
    final date = DateTime(activity.date.year, activity.date.month, activity.date.day);
    if (eventSource[date] == null) {
      eventSource[date] = [];
    }
    eventSource[date]!.add(Event('Nota',activity.name, activity.description));
  }
  for (final raccolto in raccolto) {
    final date = DateTime(raccolto.data.year, raccolto.data.month, raccolto.data.day);
    if (eventSource[date] == null) {
      eventSource[date] = [];
    }
    eventSource[date]!.add(Event('Raccolto', raccolto.nome, raccolto.description));
  }
  for (final spesa in spese) {
    final date = DateTime(spesa.date.year, spesa.date.month, spesa.date.day);
    if (eventSource[date] == null) {
      eventSource[date] = [];
    }
    eventSource[date]!.add(Event('Spesa', spesa.name, spesa.description));
  }
  return eventSource;
}



final LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

