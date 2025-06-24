import 'package:flutter/material.dart';

void main() {
  runApp(const GestionPublicitesApp());
}

class GestionPublicitesApp extends StatelessWidget {
  const GestionPublicitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PubliciteListingPage(),
    );
  }
}

class PubliciteListingPage extends StatefulWidget {
  const PubliciteListingPage({super.key});

  @override
  State<PubliciteListingPage> createState() => _PubliciteListingPageState();
}

class _PubliciteListingPageState extends State<PubliciteListingPage> {
  // Données simulées
  List<Map<String, dynamic>> videos = [
    {'id': 1, 'titre': 'Pub vidéo 1', 'date': '2025-06-01', 'actif': true},
    {'id': 2, 'titre': 'Pub vidéo 2', 'date': '2025-06-15', 'actif': false},
  ];

  List<Map<String, dynamic>> images = [
    {'id': 3, 'titre': 'Pub image 1', 'date': '2025-06-05', 'actif': true},
  ];

  List<Map<String, dynamic>> bannieres = [
  {'id': 4, 'titre': 'Pub bannière 1', 'date': '2025-06-10', 'actif': true},
  ];

  void supprimer(List<Map<String, dynamic>> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  void modifier(Map<String, dynamic> pub) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Modifier : ${pub['titre']}")),
    );
  }

  void toggleActivation(Map<String, dynamic> pub) {
    setState(() {
      pub['actif'] = !(pub['actif'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: const Text(
            'Gestion des publicités',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.red),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: 'Vidéos'),
              Tab(text: 'Images'),
              Tab(text: 'Bannières'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildPubList(videos, 'Vidéo'),
            buildPubList(images, 'Image'),
            buildPubList(bannieres, 'Bannière'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Naviguer'),
            BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Itinéraire'),
            BottomNavigationBarItem(icon: Icon(Icons.navigation), label: 'Indications'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Publicité'),
          ],
        ),
      ),
    );
  }

  Widget buildPubList(List<Map<String, dynamic>> pubs, String type) {
    if (pubs.isEmpty) {
      return Center(child: Text('Aucune publicité $type enregistrée.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: pubs.length,
      itemBuilder: (context, index) {
        final pub = pubs[index];
        final bool actif = pub['actif'] as bool;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pub['titre'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Date : ${pub['date']}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => modifier(pub),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Modifier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => supprimer(pubs, index),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Supprimer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => toggleActivation(pub),
                    icon: Icon(actif ? Icons.pause_circle : Icons.play_circle, size: 16),
                    label: Text(actif ? 'Stopper' : 'Activer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actif ? Colors.red.shade700 : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
