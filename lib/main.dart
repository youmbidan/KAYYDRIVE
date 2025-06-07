import 'package:flutter/material.dart';
import 'Views/Gestion_publicite/Ajouterunepublicite.dart';
import 'Views/Gestion_recompenses/Affichermesrecompenses.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayy Drive',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/ajouterPub': (context) => AjouterPublicitePage(),
        '/recompenses': (context) => Affichermesrecompenses(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/ajouterPub'),
              child: const Text('Ajouter une publicité'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/recompenses'),
              child: const Text('Voir mes récompenses'),
            ),
          ],
        ),
      ),
    );
  }
}
