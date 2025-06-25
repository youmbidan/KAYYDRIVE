// nav_state.dart
import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final List<NavItem> visibleItems = [
    NavItem(icon: Icons.map, label: 'Naviguer'),
    NavItem(icon: Icons.directions_car_filled, label: 'Itinéraire'),
    NavItem(icon: Icons.directions, label: 'Indication'),
    NavItem(icon: Icons.notifications, label: 'Notification'),
  ];

  final List<NavItem> hiddenItems = [
    NavItem(icon: Icons.tv, label: 'Publicite'),
    NavItem(icon: Icons.card_giftcard, label: 'Recompense'),
    NavItem(icon: Icons.chat, label: 'Chatbot'),
    NavItem(icon: Icons.hub, label: 'Prediction'),
    NavItem(icon: Icons.car_crash_outlined, label: 'Incident'),
  ];

  void navigate(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();

    final routes = {
      0: '/',
      1: '/itineraire',
      2: '/indication',
      3: '/notification',
      4: '/administrerPub',
      5: '/recompenses',
      6: '/chatbot',
      7: '/trafficPrediction',
      8: '/incident',
    };

    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!);
    }
  }
}
