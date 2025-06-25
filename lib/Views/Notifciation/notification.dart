import "package:flutter/material.dart";
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kayydrive/Views/Composant/CustomDrawer.dart';
import 'package:latlong2/latlong.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Color primaryColor = Colors.red; // Variable pour la couleur principale

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        Colors.red; // Variable pour la couleur principale
    final mapController = MapController();
    LatLng? userPosition;
    final navState = Provider.of<NavigationState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: primaryColor, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(
        primaryColor: primaryColor,
        mapController: mapController,
        userPosition: userPosition,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNotification(
              Icons.check_circle,
              "Confirmation",
              "Votre commande a été validée avec succès.",
              Colors.green,
            ),
            _buildNotification(
              Icons.error,
              "Erreur",
              "Une erreur s'est produite lors du paiement.",
              Colors.red,
            ),
            _buildNotification(
              Icons.warning,
              "Avertissement",
              "Votre abonnement expire bientôt.",
              Colors.orange,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: navState.selectedIndex,
        onItemTapped: (index) => navState.navigate(index, context),
        visibleItems: navState.visibleItems,
        hiddenItems: navState.hiddenItems,
      ),
    );
  }

  Widget _buildNotification(
    IconData icon,
    String title,
    String description,
    Color iconColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
