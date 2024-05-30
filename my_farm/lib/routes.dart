import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_farm/screens/chartPage.dart';
import 'package:my_farm/screens/insertRaccolto.dart';
import 'package:my_farm/screens/listBarPage.dart';
import 'package:my_farm/screens/mapPage.dart';
import 'package:my_farm/screens/userPage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:my_farm/screens/homePage.dart';
import 'package:my_farm/screens/calendarPage.dart';
import 'package:my_farm/screens/insertPage.dart';
import 'package:my_farm/screens/insertSpesa.dart';
import 'package:my_farm/widgets/floatingButton.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BottomNavigationBarWidget(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/calendar',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const TableEvents(),
        ),
        GoRoute(
          path: '/insertData',
          //parentNavigatorKey: _shellNavigatorKey, 
          builder: (context, state) => const InsertPage(),
        ),
        GoRoute(
          path: '/insertSpesa',
          parentNavigatorKey: _shellNavigatorKey, 
          builder: (context, state) => const InsertSpesa(),
        ),
        GoRoute(
          path: '/userPage',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const UserPage(),
        ),
        GoRoute(
          path: '/listBarPage',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ListBarPage(),
        ),
        GoRoute(
          path: '/insertRaccolto',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const InsertRaccolto(),
        ),
        GoRoute(
          path: '/chartPage',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ChartPage(),
        ),
        GoRoute(
          path: '/map',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const MapPage(),
        ),

      ],
    ),
  ],
);

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({
    super.key, 
    required this.child,
  });

  final dynamic child;

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  void changePage(int index) {

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/chartPage');
        break;
      case 3:
        context.go('/listBarPage');
        break;

      default:
        context.go('/home');
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La mia azienda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Open settings page
              context.go('/userPage');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 247, 215, 224),
              Color.fromARGB(255, 191, 245, 227),
            ],
          ),
        ),
        child: widget.child,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FloatingButtonWidget(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            changePage(index);
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: Colors.purple,
            ),
            //calendar page
            SalomonBottomBarItem(
              icon: const Icon(Icons.calendar_today),
              title: const Text('Calendario'),
              selectedColor: Colors.orange,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.insert_chart_outlined),
              title: const Text('Grafico'),
              selectedColor: Colors.teal,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.list),
              title: const Text('Visualizza'),
              selectedColor: const Color.fromARGB(255, 223, 114, 177),
            ),
          ],
        ),
      ),
    );
  }
}