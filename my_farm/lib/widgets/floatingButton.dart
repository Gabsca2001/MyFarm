import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingButtonWidget extends StatelessWidget {
  FloatingButtonWidget({
    super.key,
  });

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: _key,
      duration: const Duration(milliseconds: 500),
      distance: 100,
      type: ExpandableFabType.up,
      pos: ExpandableFabPos.right,
      childrenOffset: const Offset(0, 20),
      fanAngle: 40,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 54, 228, 147),
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 124, 216, 173),
        shape: const CircleBorder(),
        
      ),
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 5,
      ),
      
      children: [
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.add),
          label: const Text('Registra un\'attività'),
          onPressed: () {
            context.go('/insertData');
          },
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 113, 218, 160),
          elevation: 1,
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.balance_outlined),
          label: const Text('Registra una raccolta'),
          onPressed: () {
            context.go('/insertRaccolto');
          },
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 113, 218, 160),
          elevation: 1,
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.money_off),
          label: const Text('Registra una spesa'),
          onPressed: () {
            context.go('/insertSpesa');
          },
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 113, 218, 160),
          elevation: 1,
        ),
      ],
    );
  }
}