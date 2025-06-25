import 'package:flutter/material.dart';

class AjoutIncidentPage extends StatelessWidget {
  const AjoutIncidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryRed = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un incident"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Catégorie
            const Text("Categorie", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.red),
                hint: const Text("Selectionner"),
                items: ['Incendie', 'Panne', 'Vol'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),

            const SizedBox(height: 20),

            // Localisation
            const Text("Localisation", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Saisir la localisation",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryRed),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryRed, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Titre
            const Text("Titre", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Saisir le titre",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryRed),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryRed, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Row(
              children: const [
                Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("(facultatif)", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ajouter une description",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryRed),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryRed, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bouton Ajouter une photo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed.withOpacity(0.3),
                  foregroundColor: primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {},
                icon: const Icon(Icons.camera_alt),
                label: const Text("Ajouter une photo"),
              ),
            ),

            const SizedBox(height: 30),

            // Bouton Soumettre
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Soumettre", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
