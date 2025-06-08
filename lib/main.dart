import 'package:flutter/material.dart';
import 'package:kayydrive/Gestion_incidents/IncidentDetailPage.dart';
import 'package:kayydrive/Gestion_incidents/consultIncident.dart'; // Nommage corrigé

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.red),
          actionsIconTheme: IconThemeData(color: Colors.red),
        ),
      ),
      // Utilisez initialRoute et routes au lieu de home
      initialRoute: '/',
      // Configuration des routes
      routes: {
        // Route pour la page principale (déjà définie comme home)
        '/': (context) => const IncidentPage(),
        // Route pour les détails d'incident
        '/incident/detail': (context) => const IncidentDetailPage(),
        // Route pour ajouter un incident
        //'/incident/add': (context) => const AddIncidentPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}