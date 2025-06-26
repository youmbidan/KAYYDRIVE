// lib/Services/navigation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NavigationService {
  static const String _baseUrl = "http://<VOTRE_IP>:3000/itineraire";

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return _parseRouteResponse(response.body);
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de navigation: ${e.toString()}');
    }
  }

  List<LatLng> _parseRouteResponse(String responseBody) {
    final data = json.decode(responseBody);
    final geometry = data['geometry'];

    if (geometry == null || geometry['coordinates'] == null) {
      throw Exception('Réponse de l\'itinéraire invalide');
    }

    final List<dynamic> coordinates = geometry['coordinates'];
    return coordinates
        .map<LatLng>((coord) => LatLng(coord[1] as double, coord[0] as double))
        .toList();
  }
}
