import 'package:flutter/material.dart';
import 'navigation.dart';
import 'notification.dart';
import 'Indication.dart';

class MainNavigationWrapper extends StatefulWidget {
  final int initialIndex;
  const MainNavigationWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NavigationPage(),
    Center(child: Text("Itinéraire (à venir)")),
    IndicationPage(),
    NotificationPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Naviguer"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Itinéraire"),
          BottomNavigationBarItem(icon: Icon(Icons.directions), label: "Indication"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
        ],
      ),
    );
  }
}
