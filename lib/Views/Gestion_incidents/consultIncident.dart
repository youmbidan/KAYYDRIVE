import 'package:flutter/material.dart';
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';

class IncidentPage extends StatefulWidget {
  const IncidentPage({super.key});

  @override
  State<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends State<IncidentPage> {
  String? _selectedItem1, _selectedItem2, _selectedItem3;
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

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
                // Navigation vers les détails de l'incident
                Navigator.pushNamed(context, '/incident/detail');
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
                  height: 180,
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
                            Text(
                              "Rue Douala 3ème",
                              style: TextStyle(fontSize: 14),
                            ),
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
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/incident/add');
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: navState.selectedIndex,
        onItemTapped: (index) => navState.navigate(index, context),
        visibleItems: navState.visibleItems,
        hiddenItems: navState.hiddenItems,
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
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor),
          ),
        ),
      ),
    );
  }
}
