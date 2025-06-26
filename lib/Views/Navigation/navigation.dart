import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:kayydrive/Views/Composant/CustomDrawer.dart';
import 'package:kayydrive/Services/navigation_service.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final Color primaryColor = Colors.red;
  final MapController mapController = MapController();
  final NavigationService _navigationService = NavigationService();
  LatLng start = LatLng(3.970977, 9.791324);
  LatLng? end;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  final TextEditingController _typeAheadController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  void _updateMarkers() {
    setState(() {
      _markers = [
        Marker(
          point: start,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_on, color: Colors.red),
        ),
        if (end != null)
          Marker(
            point: end!,
            width: 40,
            height: 40,
            child: const Icon(Icons.flag, color: Colors.green),
          ),
      ];
    });
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

  Future<void> _fetchRoute(LatLng destination) async {
    setState(() => _isLoading = true);

    try {
      final points = await _navigationService.getRoute(start, destination);

      setState(() {
        _polylines = [
          Polyline(points: points, strokeWidth: 4, color: Colors.blue),
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de navigation: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void goToPlace(double lat, double lon, String displayName) {
    final point = LatLng(lat, lon);

    setState(() {
      end = point;
      _updateMarkers();
      _polylines = [];
    });

    mapController.move(point, 15);
    _fetchRoute(point);
  }

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);
    LatLng? userPosition;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
        centerTitle: true,
        title: SizedBox(
          height: 40,
          child: TypeAheadField<Map<String, dynamic>>(
            controller: _typeAheadController,
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: "Rechercher une destination...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              return await searchLocation(pattern);
            },
            itemBuilder: (context, Map<String, dynamic> suggestion) {
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(suggestion['display_name']),
              );
            },
            onSelected: (Map<String, dynamic> suggestion) {
              final lat = double.parse(suggestion['lat']);
              final lon = double.parse(suggestion['lon']);
              goToPlace(lat, lon, suggestion['display_name']);
              _typeAheadController.text = suggestion['display_name'];
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(
        primaryColor: primaryColor,
        mapController: mapController,
        userPosition: userPosition,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: start,
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                // Optionnel: Ajouter un marqueur au clic sur la carte
                setState(() {
                  end = point;
                  _updateMarkers();
                  _polylines = [];
                });
                _fetchRoute(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.kayy_drive',
              ),
              MarkerLayer(markers: _markers),
              PolylineLayer(polylines: _polylines),
            ],
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Optionnel: Recentrer sur la position de départ
          mapController.move(start, 15);
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.my_location, color: Colors.white),
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
