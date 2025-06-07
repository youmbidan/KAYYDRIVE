import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MaterialApp(
    home: Affichermesrecompenses(),
    debugShowCheckedModeBanner: false,
  ));
}

class Affichermesrecompenses extends StatelessWidget {
  const Affichermesrecompenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text(
          'Mes Récompenses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.notifications_none, color: Colors.red),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          RewardCard(
            logo:
            'https://logoeps.com/wp-content/uploads/2013/05/spar-eps-vector-logo.png',
            title: 'Bon de réduction 30%',
            description: 'valable sur tous les produits au supermarché SPAR.',
            expiry: '15/06/2025',
          ),
          SizedBox(height: 12),
          RewardCard(
            logo:
            'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgC3rQchpzH6ZStyzWL1y4xB3Ki4hB-ECQiaMHDeQAyJMcWqDYJn8dSkbgaAz0MhaKS8Jv5ZxtgkKeAw0EDprS5L5f00qfKvOEnWyJ8PNMoaQ36ihpLZu4BIsFWya_cXaArmVU2Z7zWV33u1Jcr710vukWHOJDy1QogUMf72BalN1uzT0J6nORGgRysMVcd/s320/BLESSING%20LOGO%20FINAL%202024.png',
            title: '10% de réduction sur l’essence',
            description:
            'Réduction valable dans toutes les stations BLESSING participantes.',
            expiry: '30/06/2025',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Naviguer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route),
            label: 'Itinéraire',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_direction),
            label: 'Indications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Récompense',
          ),
        ],
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String logo;
  final String title;
  final String description;
  final String expiry;

  const RewardCard({
    super.key,
    required this.logo,
    required this.title,
    required this.description,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logo.endsWith('.svg')
                ? SvgPicture.network(logo, height: 50)
                : Image.network(logo, height: 80),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(description),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Expire le $expiry',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Disponible',
                    style: TextStyle(color: Colors.green[800], fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Afficher le code',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
