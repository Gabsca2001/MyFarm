import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final List<String> _activityType = [
    'Irrigazione',
    'Fertilizzazione',
    'Trattamento fitosanitario',
    'Altro'
  ];
  String? _selectedActivity;

  final List<String> _workers = [
    'Mario Rossi',
    'Luca Verdi',
    'Paolo Bianchi',
  ];

  Map<String, bool> _selectedWorkers = {};

  @override
  void initState() {
    super.initState();
    // Initialize the selected workers map
    for (var worker in _workers) {
      _selectedWorkers[worker] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //form to insert data
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  icon: Icon(Icons.title),
                  helperText: 'Inserisci il nome dell\'attività',
                  helperStyle: TextStyle(
                    color: Color.fromARGB(255, 123, 230, 189),
                  ),
                ),
              ),
            ),

            //select dropdown for type of activity
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.work),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                      hint: const Text('Tipo di attività'),
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

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Descrizione',
                  icon: Icon(Icons.description),
                  helperText: 'Inserisci una descrizione dell\'attività',
                  helperStyle: TextStyle(
                    color: Color.fromARGB(255, 123, 230, 189),
                  ),
                ),
                maxLines: 2,
              ),
            ),

            //date picker for activity date
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.date_range),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2035),
                      );
                    },
                    child: const Text('Data'),
                  ),
                ],
              ),
            ),
            //time picker for activity time
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                    child: const Text('Ora'),
                  ),
                ],
              ),
            ),

            //checkbox list to select workers
            SizedBox(
              height: 200,
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
          ],
        ),
      ),
    );
  }
}
