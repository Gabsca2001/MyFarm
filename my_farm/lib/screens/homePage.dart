import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';
import 'package:my_farm/models/spesaModel.dart';
import 'package:my_farm/widgets/meteoWidget.dart';
import 'package:my_farm/widgets/noteWidget.dart';
import 'package:my_farm/widgets/spesaWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Activity> _activities = [];
  List<Spesa> _spese = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _loadSpese();
  }

  Future<void> _loadActivities() async {
    List<Activity> activities = await getActivities();
    setState(() {
      _activities = activities;
    });
  }

  Future<void> _loadSpese() async {
    List<Spesa> spese = await getSpese();
    setState(() {
      _spese = spese;
    });
  }


  @override
  Widget build(BuildContext context) {


    List<Activity> futureActivities = _activities.where((activity) => activity.date.isAfter(DateTime.now())).toList();
    List<Activity> pastActivities = _activities.where((activity) => activity.date.isBefore(DateTime.now())).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MeteoWidget(),
            const SizedBox(height: 10),
            NoteWidget(noteLabel: 'Note future', activities: futureActivities,),
            const SizedBox(height: 10),
            NoteWidget(noteLabel: 'Note passate', activities: pastActivities,),
            const SizedBox(height: 10),
            SpesaWidget(spese: _spese),

            ],
        ),
      ),
    );
  }

}