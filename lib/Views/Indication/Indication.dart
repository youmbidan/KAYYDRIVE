import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class IndicationPage extends StatefulWidget {
  @override
  State<IndicationPage> createState() => _IndicationPageState();
}

class _IndicationPageState extends State<IndicationPage> {
  final mapController = MapController();
  LatLng? userPosition;

  bool _showFilterCircle = true;
  String _selectedFilter = 'Tous';

  final List<String> _filters = ['Tous', 'Boucher', 'Ouverte', 'Événements'];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useDefaultPosition();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          _useDefaultPosition();
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userPosition = LatLng(position.latitude, position.longitude);
      });

      mapController.move(userPosition!, 14);
    } catch (e) {
      _useDefaultPosition();
    }
  }

  void _useDefaultPosition() {
    setState(() {
      userPosition = LatLng(3.970977, 9.791324); // Position de secours
    });
  }

  List<Polyline> _buildPolylines() {
    Color color;
    switch (_selectedFilter) {
      case 'Boucher':
        color = Colors.red;
        break;
      case 'Ouverte':
        color = Colors.green;
        break;
      case 'Événements':
        color = Colors.orange;
        break;
      default:
        color = Colors.blue;
    }

    return userPosition == null
        ? []
        : [
      Polyline(
        points: [
          userPosition!,
          LatLng(userPosition!.latitude + 0.01, userPosition!.longitude + 0.01),
        ],
        color: color,
        strokeWidth: 4.0,
      ),
    ];
  }

  Widget _buildIconOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 22,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Indication", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.pink),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.pink),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.pink, Colors.deepPurple]),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black87),
              title: const Text("Accueil", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigation vers Accueil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black87),
              title: const Text("Paramètres", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigation vers Paramètres
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(center: userPosition, zoom: 14),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                  ),
                ],
              ),
              PolylineLayer(polylines: _buildPolylines()),
            ],
          ),
          if (_showFilterCircle)
            Positioned(
              bottom: 110,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconOption(Icons.close, "Boucher", Colors.red),
                    _buildIconOption(Icons.check_circle, "Ouverte", Colors.green),
                    _buildIconOption(Icons.warning, "Événements", Colors.orange),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  _showFilterCircle = !_showFilterCircle;
                });
              },
              child: Icon(
                _showFilterCircle ? Icons.expand_more : Icons.expand_less,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
