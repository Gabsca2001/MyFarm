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

    List<Activity> futureActivities = _activities.where((activity) => activity.date.isAfter(DateTime.now())).toList();
    List<Activity> pastActivities = _activities.where((activity) => activity.date.isBefore(DateTime.now())).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 233, 233),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Benvenuto!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'In questa pagina puoi visualizzare le attività future e passate.',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Note future:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            //mostra le attività
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: futureActivities.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(255, 141, 231, 144),
                    child: ListTile(
                      title: Text(futureActivities[index].name),
                      subtitle: Text(futureActivities[index].description!),
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
            const SizedBox(height: 20),
            const Text(
              'Attività passate:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pastActivities.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(pastActivities[index].name),
                      subtitle: Text(pastActivities[index].description!),
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
      ),
    );
  }

}