import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final MapController mapController = MapController();
  LatLng start = LatLng(3.970977, 9.791324); // Point A
  LatLng end = LatLng(3.977971, 9.793925); // Point B

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _markers = [
      Marker(
        point: start,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, color: Colors.red),
      ),
      Marker(
        point: end,
        width: 40,
        height: 40,
        child: const Icon(Icons.flag, color: Colors.green),
      ),
    ];
  }

  Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'flutter-app'},
    );

    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body);
      return results
          .map<Map<String, dynamic>>((place) => place as Map<String, dynamic>)
          .toList();
    } else {
      return [];
    }
  }

  void goToPlace(double lat, double lon, String displayName) {
    final point = LatLng(lat, lon);
    mapController.move(point, 15);
    setState(() {
      _markers.add(
        Marker(
          point: point,
          width: 40,
          height: 40,
          child: const Icon(Icons.place, color: Colors.purple, size: 36),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.pink),
        centerTitle: true,
        title: SizedBox(
          height: 40,
          child: TypeAheadField<Map<String, dynamic>>(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                hintText: "Rechercher une destination...",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                filled: true,
                fillColor: Colors.pink.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await searchLocation(pattern);
            },
            itemBuilder: (context, Map<String, dynamic> suggestion) {
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(suggestion['display_name']),
              );
            },
            onSuggestionSelected: (Map<String, dynamic> suggestion) {
              final lat = double.parse(suggestion['lat']);
              final lon = double.parse(suggestion['lon']);
              goToPlace(lat, lon, suggestion['display_name']);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.pink),
            onPressed: () {
              // TODO: Naviguer vers le profil utilisateur
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.deepPurple],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Accueil"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Paramètres"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(center: start, zoom: 13.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.kayy_drive',
          ),
          MarkerLayer(markers: _markers),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [start, end],
                strokeWidth: 4,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: navState.selectedIndex,
        onItemTapped: (index) => navState.navigate(index, context),
        visibleItems: navState.visibleItems,
        hiddenItems: navState.hiddenItems,
      ),
    );
  }
}
