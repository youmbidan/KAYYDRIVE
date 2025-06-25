import 'package:flutter/material.dart';
import 'package:kayydrive/Views/Gestion_incidents/composant/ImageGallery.dart';
import 'package:kayydrive/Views/Composant/CustomDrawer.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kayydrive/Views/Composant/CustomDrawer.dart';
import 'package:latlong2/latlong.dart';

class IncidentDetailPage extends StatefulWidget {
  const IncidentDetailPage({super.key});

  @override
  State<IncidentDetailPage> createState() => _IncidentDetailPageState();
}

class _IncidentDetailPageState extends State<IncidentDetailPage> {
  int _selectedIndex = 0;

  final List<NavItem> _visibleItems = [
    NavItem(icon: Icons.map, label: 'Naviguer'),
    NavItem(icon: Icons.directions_car_filled, label: 'Itinéraire'),
    NavItem(icon: Icons.notifications, label: 'Notification'),
    NavItem(icon: Icons.support_agent, label: 'Assistance'),
  ];

  final List<NavItem> _hiddenItems = [
    NavItem(icon: Icons.settings, label: 'Réglages'),
    NavItem(icon: Icons.history, label: 'Historique'),
    NavItem(icon: Icons.favorite, label: 'Favoris'),
    NavItem(icon: Icons.share, label: 'Partager'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        Colors.red; // Variable pour la couleur principale
    final mapController = MapController();
    LatLng? userPosition;

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("Détails de l'incident"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFFCE6E6),
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Étiquette "Signalé"
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 6,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Grave",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 150),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEB8A8A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Signalé',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Icon(Icons.warning, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Collision entre deux vehicule",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          Icon(Icons.location_on, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Rue Douala 3ème",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.calendar_month, size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Le 15 avril 19h45",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ImageGallery(),
                      Row(
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 15),
                          const SizedBox(width: 6),
                          const Text(
                            "Photo ajoutées par l'utilisateur",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Signalé par",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "Nom : ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "la communauté urbaine de Douala 3ème.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "Tel : ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "+237 671639978",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F1ED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 11),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEB8A8A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minHeight: 100),
                        child: SingleChildScrollView(
                          child: const Text(
                            'Ceci est un long texte figé à l\'intérieur du conteneur. '
                            'Il sera scrollable si son contenu dépasse la hauteur du container. '
                            'Tu peux continuer à écrire ici autant que tu veux. '
                            'Ce comportement est utile pour afficher des journaux, des descriptions longues, etc.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Commentaires",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Ajouter un commentaire...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.send,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      commentWidget(
                        "Utilisateur1",
                        "Merci pour le signalement.",
                      ),
                      commentWidget(
                        "Agent de sécurité",
                        "Un véhicule d’intervention est en route.",
                      ),
                      commentWidget(
                        "Utilisateur2",
                        "Je suis passé par là. C’est vraiment grave.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentWidget(String auteur, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.person, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auteur,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(message, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
