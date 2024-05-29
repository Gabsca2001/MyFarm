import 'package:flutter/material.dart';
import 'package:my_farm/screens/listBarPage.dart';
import 'package:my_farm/widgets/noteDialog.dart';
class NoteCard extends StatelessWidget {
  final String name;
  final String description;
  final DateTime date;
  final TimeOfDay? time;
  final List<String>? workers;

  const NoteCard({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    this.time,
    this.workers,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //show dialog
        showDialog(
          context: context,
          builder: (context) {
            return NoteDialog(name: name, description: description, date: date);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Text(
                  name.length > 20 ? '${name.substring(0, 20)}...' : name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description.length > 5
                  ? '${description.substring(0, 5)}...'
                  : description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
