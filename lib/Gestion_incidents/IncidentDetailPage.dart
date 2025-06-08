import 'package:flutter/material.dart';
import 'package:kayydrive/Gestion_incidents/composant/ImageGallery.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IncidentDetailPage extends StatefulWidget {
  const IncidentDetailPage({super.key});

  @override
  State<IncidentDetailPage> createState() => _IncidentDetailPageState();
}

class _IncidentDetailPageState extends State<IncidentDetailPage> {
  int _selectedIndex = 0;
  bool _expanded = false;

  // Boutons visibles (4 boutons en colonne)
  final List<NavItem> _visibleItems = [
    NavItem(icon: Icons.map, label: 'Naviguer'),
    NavItem(icon: Icons.directions_car_filled, label: 'Itinéraire'),
    NavItem(icon: Icons.notifications, label: 'Notification'),
    NavItem(icon: Icons.support_agent, label: 'Assistance'),
  ];

  // Boutons cachés
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
              onTap: () {
                // Action au clic
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFFCE6E6),
                shadowColor: Colors.black.withOpacity(0.2),
                child: SizedBox(
                  width: 400,
                  height: 800,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 16,
                        child: Container(
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
                      ),
                      Positioned(
                        top: 10,
                        left: 40,
                        right: 16,
                        bottom: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Grave",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
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
                            const SizedBox(height: 4),
                            ImageGallery(),
                            Row(
                              children: [
                                Icon(Icons.camera_alt_outlined, size: 15),
                                SizedBox(width: 6),
                                const Text(
                                  "Photo ajoutees par l'utilisateur",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
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
                                  "Nom: ",
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
                                  "Tel: ",
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
                            SizedBox(
                              height: 100,
                              width: 300,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F1ED),
                                  borderRadius: BorderRadius.circular(20),
                                ),
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
                              height:
                                  100, // hauteur fixée pour permettre le scroll interne
                              child: SingleChildScrollView(
                                child: Text(
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
                          ],
                        ),
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
}

// Classe helper pour les items de navigation
class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
