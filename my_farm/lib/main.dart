import 'package:flutter/material.dart';
import 'package:my_farm/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Farm',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
