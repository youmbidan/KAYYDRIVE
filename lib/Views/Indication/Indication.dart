import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';

class IndicationPage extends StatefulWidget {
  @override
  State<IndicationPage> createState() => _IndicationPageState();
}

class _IndicationPageState extends State<IndicationPage> {
  final Color primaryColor = Colors.red; // Variable pour la couleur principale
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
      userPosition = LatLng(3.970977, 9.791324);
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
                LatLng(
                  userPosition!.latitude + 0.01,
                  userPosition!.longitude + 0.01,
                ),
              ],
              color: color,
              strokeWidth: 4.0,
            ),
          ];
  }

  Widget _buildIconOption(IconData icon, String label, Color color) {
    bool isSelected = _selectedFilter == label;
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
            backgroundColor: isSelected ? color.withOpacity(0.8) : Colors.white,
            radius: 22,
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

    if (userPosition == null) {
      return Scaffold(
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.red),
              SizedBox(height: 16),
              Text(
                "Localisation en cours...",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: navState.selectedIndex,
          onItemTapped: (index) => navState.navigate(index, context),
          visibleItems: navState.visibleItems,
          hiddenItems: navState.hiddenItems,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "Indication",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
              leading: Icon(Icons.home, color: Colors.black87),
              title: Text("Accueil", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.black87),
              title: Text("Ma position", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                if (userPosition != null) {
                  mapController.move(userPosition!, 16);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black87),
              title: Text("Paramètres", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black87),
              title: Text("À propos", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: userPosition!,
                initialZoom: 14.0,
                minZoom: 3.0,
                maxZoom: 18.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.kayydrive',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userPosition!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(polylines: _buildPolylines()),
              ],
            ),
          ),
          if (_showFilterCircle)
            Positioned(
              bottom: 110,
              left: MediaQuery.of(context).size.width / 2 - 120,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconOption(Icons.close, "Boucher", Colors.red),
                      _buildIconOption(
                        Icons.check_circle,
                        "Ouverte",
                        Colors.green,
                      ),
                      _buildIconOption(
                        Icons.warning,
                        "Événements",
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: () {
                setState(() {
                  _showFilterCircle = !_showFilterCircle;
                });
              },
              child: AnimatedRotation(
                turns: _showFilterCircle ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _showFilterCircle ? Icons.expand_more : Icons.expand_less,
                  color: primaryColor,
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: () {
                if (userPosition != null) {
                  mapController.move(userPosition!, 16);
                }
              },
              child: Icon(Icons.my_location, color: primaryColor),
            ),
          ),
          if (_selectedFilter != 'Tous')
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _selectedFilter == 'Boucher'
                          ? Icons.close
                          : _selectedFilter == 'Ouverte'
                          ? Icons.check_circle
                          : Icons.warning,
                      size: 16,
                      color: _selectedFilter == 'Boucher'
                          ? Colors.red
                          : _selectedFilter == 'Ouverte'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Filtre: $_selectedFilter',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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
