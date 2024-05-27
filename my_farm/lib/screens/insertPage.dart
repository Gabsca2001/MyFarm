import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';
import 'package:go_router/go_router.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {

  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Activity> _activities = [];

  String _nameActivity = '';

  String _description = '';

  //text controller for the name of the activity
  late TextEditingController _nameController;

  late List<String> _activityType;

  String? _selectedActivity;

  late List<String> _workers;

  final Map<String, bool> _selectedWorkers = {};

  //date picker
  DateTime? _selectedDate;
  // Time picker
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _workers = getWorkers();
    _activityType = getActivityTypes();
    // Initialize the selected workers map
    for (var worker in _workers) {
      _selectedWorkers[worker] = false;
    }
    _loadActivities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadActivities() async {
    List<Activity> activities = await getActivities();
    setState(() {
      _activities = activities;
    });
  }


  Future<void> _saveActivity() async {

    //check if all the fields are filled
    if (_nameActivity == '' || _selectedActivity == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compila tutti i campi obbligatori'),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
      return;
    }

    print('Saving activity...');

    _selectedTime ??= TimeOfDay.now();

    Activity newActivity = Activity(
      name: _nameActivity,
      type: _selectedActivity!,
      description: _description,
      date: _selectedDate!,
      time: _selectedTime!,
      workers: _selectedWorkers.keys.where((worker) => _selectedWorkers[worker]!).toList(),
    );
    _activities.add(newActivity);
    await storeActivities(_activities);
    print('Activity saved: $newActivity');
  }



  //set the name of the activity
  void _setNameActivity(String value) {
    setState(() {
      _nameActivity = value;
    });
  }

  void _setDescription(String value) {
    setState(() {
      _description = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    //form to insert data
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //back button
          Container(
            margin: const EdgeInsets.all(16),
            child: IconButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 142, 212, 174)),
                iconSize: MaterialStateProperty.all(30),
              ),
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 230, 188),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _nameController,
                        onChanged: _setNameActivity,
                        decoration: const InputDecoration(
                          labelText: 'Nome attività *',
                          icon: Icon(Icons.title),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
          
                    //select dropdown for type of activity
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.work),
                          const SizedBox(width: 20),
                          DropdownButton<String>(
                              hint: const Text('Tipo di attività *'),
                              value: _selectedActivity,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: _activityType.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedActivity = value;
                                });
                              },
                              style: const TextStyle(
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
          
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: _setDescription,
                        decoration: const InputDecoration(
                          labelText: 'Descrizione',
                          icon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                    ),
          
                    //date picker for activity date
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Text(_selectedDate == null
                                ? 'Seleziona la data *'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                          ),
                        ],
                      ),
                    ),
                    //time picker for activity time
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 20),
                          //time picker withouth button to show time
                          GestureDetector(
                            onTap: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              setState(() {
                                _selectedTime = time;
                              });
                            },
                            child: Text(_selectedTime == null
                                ? '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}'
                                : '${_selectedTime!.hour}:${_selectedTime!.minute}'),
                          ),
                        ],
                      ),
                    ),
          
                    //checkbox list to select workers
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: _workers.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(_workers[index]),
                            value: _selectedWorkers[_workers[index]],
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedWorkers[_workers[index]] = value!;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    //button to submit the form
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 16),
                      child: ElevatedButton(
                        onPressed: _saveActivity,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 66, 124, 76)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)),
                          elevation: MaterialStateProperty.all(2),
                        ),
                        child: const Text('Inserisci'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
