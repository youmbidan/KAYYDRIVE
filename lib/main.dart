import 'package:flutter/material.dart';
import 'package:kayydrive/Gestion_incidents/consultIncident.dart'; // Nommage corrigé

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Incidents', // Titre pour l'accessibilité
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Fond blanc pour toutes les AppBars
          iconTheme: IconThemeData(color: Colors.red), // Icônes rouges
          actionsIconTheme: IconThemeData(color: Colors.red), // Icônes d'actions rouges
        ),
      ),
      home: const IncidentPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}