import 'package:flutter/material.dart';

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
    return Scaffold(
      drawer: Drawer(), // <-- Menu latéral gauche
      appBar: AppBar(
        centerTitle: true,
        title: Text("Gestion des Incidents") ,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle), // Icône "compte"
            tooltip: 'Informations du compte', // Info-bulle (affichée au survol)
            onPressed: () {
            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),  // Réduction du padding général
        child: Column(
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
                  label: 'Region',
                  onChanged: (value) => setState(() => _selectedItem3 = value),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Text(
            //   'Sélections : ${_selectedItem1 ?? '-'}, ${_selectedItem2 ?? '-'}, ${_selectedItem3 ?? '-'}',
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            // Container Carré Thématique
            GestureDetector(
              onTap: () {
                // Action au clic
              },
              child: Card(
                elevation: 24, // Contrôle l'ombre Material Design (0-24)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shadowColor: Colors.black.withOpacity(0.1),
                child: SizedBox(
                  width: 400,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                          ],
                        )
                    ],
                  ),
                ),
              )
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
    final theme = Theme.of(context); // Récupère le thème actuel
    final primaryColor = theme.colorScheme.primary; // Couleur principale (rouge)

    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1), // Fond rouge très léger
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            value: value,
            icon: Icon(Icons.arrow_drop_down, color: primaryColor), // Icône rouge
            dropdownColor: Colors.white, // Fond blanc pour le menu déroulant
            hint: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: primaryColor.withOpacity(0.8), // Texte rouge semi-transparent
                fontWeight: FontWeight.w500,
              ),
            ),
            items: _items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black87, // Texte noir pour lisibilité
                ),
              ),
            )).toList(),
            onChanged: onChanged,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: primaryColor, // Texte sélectionné en rouge
            ),
          ),
        ),
      ),
    );
  }



}

