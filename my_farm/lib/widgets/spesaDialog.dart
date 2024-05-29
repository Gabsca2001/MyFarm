import 'package:flutter/material.dart';

class SpesaDialog extends StatelessWidget {

  final String name;
  final String store;
  final double price;
  final DateTime date;
  final String description;
  

  const SpesaDialog({
    super.key, required this.name, required this.store, required this.price, required this.date, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
                child: const Icon(Icons.shopping_cart),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //close button
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Negozio: ', style: TextStyle(fontWeight: FontWeight.w600),),
              Text(store),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Prezzo: ', style: TextStyle(fontWeight: FontWeight.w600),),
              Text('$price€'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Data: ', style: TextStyle(fontWeight: FontWeight.w600),),
              Text('${date.day}/${date.month}/${date.year}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Descrizione: ', style: TextStyle(fontWeight: FontWeight.w600),),
              Flexible(child: Text(description)),
            ],
          ),
        ],
      ),
    );
  }
}
