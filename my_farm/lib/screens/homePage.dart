import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Activity> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    List<Activity> activities = await getActivities();
    setState(() {
      _activities = activities;
    });
  }

    Future<void> _deleteActivity(int index) async {
    _activities.removeAt(index);
    await storeActivities(_activities);
    setState(() {
      // Update the state to reflect the changes
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Le tue attività',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          //mostra le attività
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_activities[index].name),
                    subtitle: Text(_activities[index].description!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteActivity(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}