import "package:flutter/material.dart";
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Color primaryColor = Colors.red; // Variable pour la couleur principale

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: primaryColor, size: 40),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: primaryColor, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: primaryColor),
              title: Text("Accueil"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: primaryColor),
              title: Text("Paramètres"),
              onTap: () {},
            ),
          ],
        ),
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
