import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NavigationService {
  // Configuration de l'URL du backend
  // IMPORTANT: À adapter selon votre environnement
  static const String _baseUrl =
      "http://10.0.2.2:3000/itineraire"; // Android Emulator
  // static const String _baseUrl = "http://localhost:3000/itineraire"; // iOS Simulator
  // static const String _baseUrl = "http://<VOTRE_IP>:3000/itineraire"; // Appareil physique

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return _parseRouteResponse(response.body);
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de navigation: ${e.toString()}');
    }
  }

  List<LatLng> _parseRouteResponse(String responseBody) {
    final data = json.decode(responseBody);

    // Vérification de la structure de la réponse
    if (data == null ||
        data['geometry'] == null ||
        data['geometry']['coordinates'] == null) {
      throw Exception('Réponse de l\'itinéraire invalide: $data');
    }

    final List<dynamic> coordinates = data['geometry']['coordinates'];
    return coordinates.map<LatLng>((coord) {
      // Validation des coordonnées
      if (coord is! List || coord.length < 2) {
        throw Exception('Coordonnée invalide: $coord');
      }
      return LatLng(coord[1] as double, coord[0] as double);
    }).toList();
  }
}
