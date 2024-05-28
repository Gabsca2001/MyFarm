import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_farm/models/spesaModel.dart';

// ignore: must_be_immutable
class SpesaWidget extends StatefulWidget {

  List<Spesa> _spese;
  
  SpesaWidget({super.key, required List<Spesa> spese}) : _spese = spese;

  @override
  State<SpesaWidget> createState() => _SpesaWidgetState();
}

class _SpesaWidgetState extends State<SpesaWidget> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Spese',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black.withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: widget._spese.isNotEmpty
                ? MediaQuery.of(context).size.height * 0.3
                : 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget._spese.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      // Open dialog to delete the spesa
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            
                            title: const Text('Visualizza dettagli', style: TextStyle(fontWeight: FontWeight.w600),),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Row(
                                  children: [
                                    const Text('Nome: ', style: TextStyle(fontWeight: FontWeight.w600),),
                                    Text(widget._spese[index].name),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Store
                                Row(
                                  children: [
                                    const Text('Negozio: ', style: TextStyle(fontWeight: FontWeight.w600),),
                                    Text(widget._spese[index].store),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Price
                                Row(
                                  children: [
                                    const Text('Prezzo: ', style: TextStyle(fontWeight: FontWeight.w600),),
                                    Text('${widget._spese[index].price}€'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Date
                                Row(
                                  children: [
                                    const Text('Data: ', style: TextStyle(fontWeight: FontWeight.w600),),
                                    Text('${widget._spese[index].date.day}/${widget._spese[index].date.month}/${widget._spese[index].date.year}'),
                                  ],
                                ),
                                // Description
                                const SizedBox(height: 10),
                                Row(
                                    children: [
                                      const Text('Descrizione: ', style: TextStyle(fontWeight: FontWeight.w600),),
                                      Flexible(child: Text(widget._spese[index].description)),
                                    ],
                                  ),

                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Annulla', style: TextStyle(color: Colors.black),),
                              ),
                            ],
                          );
                        },
                      );

                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
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
                                child: const Icon(Icons.shopping_cart),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget._spese[index].name.length > 20
                                        ? '${widget._spese[index].name.substring(0, 20)}...'
                                        : widget._spese[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.store,
                                        color: Colors.black.withOpacity(0.6),
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget._spese[index].store.length > 20
                                            ? '${widget._spese[index].store.substring(0, 20)}...'
                                            : widget._spese[index].store,
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '${widget._spese[index].price}€',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}