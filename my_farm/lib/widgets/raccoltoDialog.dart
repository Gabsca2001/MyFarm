import 'package:flutter/material.dart';

class RaccoltoDialog extends StatelessWidget {

  final String name;
  final String description;
  final DateTime date;
  final double price;
  final double quantity;



  const RaccoltoDialog({super.key, required this.name, required this.description, required this.date, required this.price, required this.quantity});

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
              const Text('Quantità: ', style: TextStyle(fontWeight: FontWeight.w600),),
              Text('$quantity kg', style: const TextStyle(fontSize: 16),),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Prezzo: ', style: TextStyle(fontWeight: FontWeight.w600),),
              Text('$price €', style: const TextStyle(fontSize: 16),),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Descrizione: ', style: TextStyle(fontWeight: FontWeight.w600),),
          Text(description),
        ],
      ),
    );
  }
}