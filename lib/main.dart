import 'package:flutter/material.dart';
import 'package:kayydrive/Views/Chatbot/chat_screen.dart';
import 'package:kayydrive/Views/Gestion_publicite/AdminPublicite.dart';
import 'package:kayydrive/Views/Indication/Indication.dart';
import 'package:kayydrive/Views/Itineraire/enregistr%C3%A9.dart';
import 'package:kayydrive/Views/Itineraire/itineraire.dart';
import 'package:kayydrive/Views/Navigation/navigation.dart';
import 'package:kayydrive/Views/Notifciation/notification.dart';
import 'package:kayydrive/Views/Prediction_trafic/Prediction_trafic.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:kayydrive/Views/Gestion_incidents/IncidentDetailPage.dart';
import 'package:kayydrive/Views/Gestion_incidents/ajoutIncident.dart';
import 'package:kayydrive/Views/Gestion_incidents/consultIncident.dart'; // Nommage corrigé
import 'package:kayydrive/Views/Gestion_incidents/ajoutIncident.dart';
import 'package:kayydrive/Views/Gestion_publicite/Ajouterunepublicite.dart';
import 'package:kayydrive/Views/Gestion_recompenses/Affichermesrecompenses.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
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
        '/': (context) => NavigationPage(),
        '//incident': (context) => const IncidentPage(),
        // Route pour les détails d'incident
        '/incident/detail': (context) => const IncidentDetailPage(),
        // Route pour ajouter un incident
        '/incident/add': (context) => const AjoutIncidentPage(),
        // Route pour ajouter les publicites
        '/administrerPub': (context) => const PubliciteListingPage(),
        // Route pour consulter les Recompenses
        '/recompenses': (context) => const Affichermesrecompenses(),
        '/chatbot': (context) => ChatScreen(),
        '/trafficPrediction': (context) => TrafficPredictionScreen(),
        '/itineraire': (context) => ItineraireScreen(),
        '/enregistre': (context) => SavedAddressesPage(),
        '/indication': (context) => IndicationPage(),
        '/notification': (context) => NotificationPage(),
        '/ajouterPub': (context) => const AjouterPublicitePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
