import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_farm/models/spesaModel.dart';
import 'package:my_farm/widgets/spesaDialog.dart';

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
          const Text(
            'Spese',
            style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: widget._spese.isNotEmpty
                ? MediaQuery.of(context).size.height * 0.3
                : 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget._spese.isNotEmpty
                  ? 
                  ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget._spese.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Open dialog to delete the spesa
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SpesaDialog(
                              name: widget._spese[index].name,
                              store: widget._spese[index].store,
                              price: widget._spese[index].price,
                              date: widget._spese[index].date,
                              description: widget._spese[index].description,
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
                              blurRadius: 5,
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
                                      widget._spese[index].name.length > 10
                                          ? '${widget._spese[index].name.substring(0, 10)}...'
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
                              widget._spese[index].price.toString().length > 5
                                  ? '${widget._spese[index].price.toString().substring(0, 5)}€'
                                  : '${widget._spese[index].price}€',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                : const Center(
                  child: Text('Nessuna spesa presente'),
                ),
            ),
          ),
        ],
      ),
    );
  }
}