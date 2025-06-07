import 'package:flutter/material.dart';
import 'Views/Chatbot/chat_screen.dart';
import 'Views/Prediction_trafic/Prediction_trafic.dart';
import 'Views/itineraire/itineraire.dart';
import 'Views/itineraire/enregistré.dart'; // Ajout de l'import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Démarrer directement sur l'itinéraire (ou changez selon vos préférences)
      initialRoute: '/enregistre',
      routes: {
        '/chatbot': (context) => ChatScreen(),
        '/traffic': (context) => TrafficPredictionScreen(),
        '/itineraire': (context) => ItineraireScreen(),
        '/enregistre': (context) => SavedAddressesPage(), // Ajout de la nouvelle route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}