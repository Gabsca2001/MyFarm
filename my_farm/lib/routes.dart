import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:my_farm/screens/homePage.dart';
import 'package:my_farm/screens/calendarPage.dart';
import 'package:my_farm/screens/insertPage.dart';
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
          builder: (context, state) => const CalendarPage(),
        ),
        GoRoute(
          path: '/insertData',
          //parentNavigatorKey: _shellNavigatorKey, 
          builder: (context, state) => const InsertPage(),
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
        title: const Text('My Farm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/insertData');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Open settings page
            },
          ),
        ],
      ),
      body: widget.child,
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
              icon: const Icon(Icons.favorite),
              title: const Text('Preferiti'),
              selectedColor: Colors.teal,
            ),

          ],
        ),
      ),
    );
  }
}