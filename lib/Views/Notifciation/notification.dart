import "package:flutter/material.dart";

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 3; // Index de l'onglet actuel (notifications)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/navigation');
        break;
      case 1:
      // Itinéraire : à créer plus tard ou désactiver pour le moment
        break;
      case 2:
      // On est déjà sur la page indication
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/notification');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true, // Centre le titre
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.pink, size: 40), // Icône de menu en rose
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Ouvre le menu Drawer
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.pink, size: 30), // Icône de profil utilisateur
            onPressed: () {
              // Action sur l'icône profil (ajouter une navigation si nécessaire)
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.redAccent),
              title: Text("Accueil"),
              onTap: () {
                // Ajouter navigation ici
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.redAccent),
              title: Text("Paramètres"),
              onTap: () {
                // Ajouter navigation ici
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFFF1D6D6), // Fond rose clair
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNotification(Icons.check_circle, "Confirmation", "Votre commande a été validée avec succès.", Colors.green),
            _buildNotification(Icons.error, "Erreur", "Une erreur s'est produite lors du paiement.", Colors.red),
            _buildNotification(Icons.warning, "Avertissement", "Votre abonnement expire bientôt.", Colors.orange),
          ],
        ),
      ),

    );
  }

  Widget _buildNotification(IconData icon, String title, String description, Color iconColor) {
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
