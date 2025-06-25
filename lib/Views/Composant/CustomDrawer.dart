import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomDrawer extends StatelessWidget {
  final Color primaryColor;
  final MapController? mapController;
  final LatLng? userPosition;

  const CustomDrawer({
    Key? key,
    required this.primaryColor,
    this.mapController,
    this.userPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.black87),
            title: Text("Accueil", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.black87),
            title: Text("Ma position", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              if (userPosition != null && mapController != null) {
                mapController!.move(userPosition!, 16);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black87),
            title: Text("Paramètres", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black87),
            title: Text("À propos", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box, color: Colors.black87),
            title: Text("S'inscrire", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pushNamed(context, '/signin');
            },
          ),
          ListTile(
            leading: Icon(Icons.output, color: Colors.black87),
            title: Text("Deconnexion", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.highlight_off_rounded, color: Colors.black87),
            title: Text("Quitter", style: TextStyle(fontSize: 16)),
            onTap: () {
              //Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
