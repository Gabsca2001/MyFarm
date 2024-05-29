// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_farm/models/activityModel.dart';
import 'package:my_farm/models/spesaModel.dart';
import 'package:my_farm/models/raccoltoModel.dart';
import 'package:my_farm/utils.dart';

class TableEvents extends StatefulWidget {
  const TableEvents({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TableEventsState createState() => _TableEventsState();
}

class _TableEventsState extends State<TableEvents> {

  final LinkedHashMap<DateTime, List<Event>> _events = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  late ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = kToday;
  DateTime? _selectedDay;

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadActivities();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }



  Future<void> _loadActivities() async {
    final activities = await getActivities();
    final spese = await getSpese();
    final raccolto = await getRaccolti();
    final eventSource = generateEventSource(activities, raccolto, spese);
    setState(() {
      _events
        ..clear()
        ..addAll(eventSource);
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(outsideDaysVisible: false),
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            locale: 'it_IT',
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.event_note),
                        ),
                        title: Text(
                          '${value[index].categoryEvent} : ${value[index].title}',
                          style: 
                            const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700, 
                              color: Colors.black
                            ),
                          ),
                        subtitle: Text(
                          value[index].description ?? '',
                          style: 
                            const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400, 
                              color: Colors.black
                            ),
                          ),
                        
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
  }
}