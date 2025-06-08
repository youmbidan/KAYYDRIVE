import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IncidentPage extends StatefulWidget {
  const IncidentPage({super.key});

  @override
  State<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
  String? _selectedItem1, _selectedItem2, _selectedItem3;
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3'];

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
        centerTitle: true,
        title: const Text("Gestion des Incidents"),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Informations du compte',
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              children: [
                _buildCompactDropdown(
                  context,
                  value: _selectedItem1,
                  label: 'Quartier',
                  onChanged: (value) => setState(() => _selectedItem1 = value),
                ),
                const SizedBox(width: 8),
                _buildCompactDropdown(
                  context,
                  value: _selectedItem2,
                  label: 'Ville',
                  onChanged: (value) => setState(() => _selectedItem2 = value),
                ),
                const SizedBox(width: 8),
                _buildCompactDropdown(
                  context,
                  value: _selectedItem3,
                  label: 'Région',
                  onChanged: (value) => setState(() => _selectedItem3 = value),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  height: 170,
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                          children: const [
                            Text(
                              "Grave",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.warning, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  "Accident",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text("Rue Douala 3ème", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 4),
                            Text(
                              "Collision entre deux voitures",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Signalé par la communauté urbaine de Douala 3ème.",
                              style: TextStyle(fontSize: 13, color: Colors.black54),
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
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }
  Widget _buildCustomBottomNav() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _expanded ? 135 : 65, // Réduction supplémentaire de 5px
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2), // Réduction verticale
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flèche de contrôle (hauteur réduite)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Center(
                child: Container(
                  width: 30,
                  height: 12, // Réduit de 16 à 12
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: Colors.grey.shade600,
                    size: 12, // Réduit
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2), // Espacement réduit

            // Première ligne de boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _visibleItems.asMap().entries.map((entry) {
                return _buildNavButton(entry.key, entry.value);
              }).toList(),
            ),

            // Deuxième ligne (si étendu)
            if (_expanded) ...[
              const SizedBox(height: 4), // Espacement réduit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _hiddenItems.asMap().entries.map((entry) {
                  return _buildNavButton(entry.key + _visibleItems.length, entry.value);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(int index, NavItem item) {
    final isSelected = _selectedIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6), // Padding réduit
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? primaryColor : Colors.grey.shade600,
              size: 20, // Taille réduite
            ),
            const SizedBox(height: 1), // Espacement minimal
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey.shade600,
                fontSize: 9, // Taille de police réduite
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDropdown(
      BuildContext context, {
        required String? value,
        required String label,
        required ValueChanged<String?> onChanged,
      }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            value: value,
            icon: Icon(Icons.arrow_drop_down, color: primaryColor),
            dropdownColor: Colors.white,
            hint: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: primaryColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            items: _items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
              ),
            ))
                .toList(),
            onChanged: onChanged,
            style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
          ),
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