import 'package:flutter/material.dart';
import 'package:my_farm/models/activityModel.dart';
import 'package:my_farm/widgets/noteDialog.dart';

// ignore: must_be_immutable
class NoteWidget extends StatefulWidget {
  String? noteLabel;
  List<Activity>? activities;

  NoteWidget({super.key, this.noteLabel, this.activities});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {

  Future<void> _deleteActivity(int index) async {
    widget.activities!.removeAt(index);
    await storeActivities(widget.activities!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.noteLabel!,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          //mostra le attività
          SizedBox(
            height: widget.activities!.isNotEmpty
                ? MediaQuery.of(context).size.height * 0.3
                : 50,
            child: widget.activities!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.activities!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            //show dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return NoteDialog(
                                  name: widget.activities![index].name,
                                  description: widget.activities![index].description!,
                                  date: widget.activities![index].date,
                                  time: widget.activities![index].time,
                                  workers: widget.activities![index].workers,
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          '${widget.activities![index].date.day}/${widget.activities![index].date.month}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.activities![index].name.length > 20
                                              ? '${widget.activities![index].name.substring(0, 20)}...'
                                              : widget.activities![index].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          widget.activities![index].description!.length > 30
                                              ? '${widget.activities![index].description!.substring(0, 30)}...'
                                              : widget.activities![index].description!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //aggiungi un pulsante per eliminare l'attività
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded),
                                  color: Colors.black,
                                  onPressed: () {
                                    //show dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Elimina nota'),
                                          content: const Text(
                                              'Sei sicuro di voler eliminare questa nota?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Annulla',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deleteActivity(index);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Elimina',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      'Nessuna attività',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
