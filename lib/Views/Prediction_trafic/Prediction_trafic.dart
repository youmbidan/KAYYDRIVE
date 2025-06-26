import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Added for text-to-speech
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kayydrive/Views/Composant/CustomDrawer.dart';
import 'package:latlong2/latlong.dart';

class TrafficPredictionScreen extends StatefulWidget {
  @override
  _TrafficPredictionScreenState createState() =>
      _TrafficPredictionScreenState();
}

class _TrafficPredictionScreenState extends State<TrafficPredictionScreen>
    with TickerProviderStateMixin {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  LatLng? _selectedLocation;
  LatLng? _currentLocation;

  // Animations
  late AnimationController _buttonAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _mapAnimationController;
  late AnimationController _trafficOverlayController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardOpacityAnimation;
  late Animation<double> _trafficOpacityAnimation;

  String _selectedTrafficLevel = "Modéré";
  bool _showResults = false;
  String _predictionMessage = "";
  bool _isPredictionLoading = false;
  bool _isVoiceEnabled = true; // Added to toggle voice assistant
  double _ttsVolume = 1.0; // Added for volume control

  // Données de trafic pour la visualisation
  List<TrafficData> _trafficData = [];
  List<TrafficRoute> _trafficRoutes = [];

  final MapController _mapController = MapController();
  final FlutterTts _flutterTts = FlutterTts(); // Added for text-to-speech

  @override
  void initState() {
    super.initState();
    _timeController.text = "09:00";
    _locationController.text = "Recherche en cours...";

    _initializeAnimations();
    _initializeTts(); // Added to initialize TTS
    _getCurrentLocation();
    _generateTrafficData();
  }

  void _initializeAnimations() {
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _mapAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _trafficOverlayController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _cardSlideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _cardAnimationController,
            curve: Curves.easeOutBack,
          ),
        );
    _cardOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeIn),
    );
    _trafficOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _trafficOverlayController, curve: Curves.easeIn),
    );
  }

  // Initialize the Text-to-Speech engine
  void _initializeTts() async {
    try {
      await _flutterTts.setLanguage("fr-FR"); // Set language to French
      await _flutterTts.setSpeechRate(0.5); // Set speech rate
      await _flutterTts.setVolume(_ttsVolume); // Set initial volume
      await _flutterTts.setPitch(1.0); // Set pitch

      // Set audio category for iOS to ensure playback is not muted
      await _flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.duckOthers,
          ]);

      // Log initialization status
      print('TTS initialized successfully with volume: $_ttsVolume');
    } catch (e) {
      print('Error initializing TTS: $e');
    }

    // Test TTS with a sample message
    if (_isVoiceEnabled) {
      await _flutterTts.speak("Initialisation de l'assistant vocal terminée.");
    }
  }

  // Update TTS volume
  void _updateTtsVolume(double volume) async {
    setState(() {
      _ttsVolume = volume;
    });
    try {
      await _flutterTts.setVolume(volume);
      print('TTS volume updated to: $volume');
      if (_isVoiceEnabled) {
        await _flutterTts.speak("Volume réglé à ${volume.toStringAsFixed(1)}.");
      }
    } catch (e) {
      print('Error updating TTS volume: $e');
    }
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _cardAnimationController.dispose();
    _mapAnimationController.dispose();
    _trafficOverlayController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _typeAheadController.dispose();
    _flutterTts.stop(); // Stop TTS on dispose
    super.dispose();
  }

  void _generateTrafficData() {
    final random = math.Random();
    final centerLat = 4.051056;
    final centerLng = 9.767868;

    _trafficData.clear();
    _trafficRoutes.clear();

    for (int i = 0; i < 50; i++) {
      final lat = centerLat + (random.nextDouble() - 0.5) * 0.1;
      final lng = centerLng + (random.nextDouble() - 0.5) * 0.1;
      final intensity = random.nextDouble();

      _trafficData.add(
        TrafficData(
          position: LatLng(lat, lng),
          intensity: intensity,
          speed: 20 + (1 - intensity) * 60,
        ),
      );
    }

    _generateTrafficRoutes();
  }

  void _generateTrafficRoutes() {
    final List<TrafficRoute> routes = [
      TrafficRoute(
        points: [
          LatLng(4.041056, 9.757868),
          LatLng(4.051056, 9.767868),
          LatLng(4.061056, 9.777868),
        ],
        trafficLevelIdentifier: TrafficLevel.heavy,
      ),
      TrafficRoute(
        points: [LatLng(4.031056, 9.767868), LatLng(4.071056, 9.767868)],
        trafficLevelIdentifier: TrafficLevel.moderate,
      ),
      TrafficRoute(
        points: [LatLng(4.051056, 9.747868), LatLng(4.051056, 9.787868)],
        trafficLevelIdentifier: TrafficLevel.light,
      ),
    ];

    _trafficRoutes.addAll(routes);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationController.text =
            "Les services de localisation sont désactivés.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationController.text = "Permission de localisation refusée.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationController.text =
            "Permission de localisation refusée définitivement.";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationController.text = "Position actuelle";
        _selectedLocation = _currentLocation;
      });

      await _reverseGeocodeCurrentLocation(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print('Erreur lors de la récupération de la position: $e');
      setState(() {
        _locationController.text =
            "Erreur lors de la récupération de la position.";
      });
    }
  }

  Future<void> _reverseGeocodeCurrentLocation(double lat, double lon) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json';
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent': 'KAYYDRIVE-App/1.0 (danieleyoumbi@gmail.com)',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _locationController.text =
              data['display_name'] ?? "Position actuelle";
          _typeAheadController.text =
              data['display_name'] ?? "Position actuelle";
        });
      }
    } catch (e) {
      print('Erreur de connexion lors du géocodage inverse: $e');
    }
  }

  Future<void> _animateToLocation(LatLng location) async {
    _mapController.move(location, 15.0);
    _mapAnimationController.forward().then((_) {
      _mapAnimationController.reset();
    });
  }

  Future<void> _predictTrafficWithAI() async {
    if (_dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _locationController.text == "Recherche en cours...") {
      setState(() {
        _predictionMessage = "Veuillez remplir tous les champs.";
      });
      if (_isVoiceEnabled) {
        await _flutterTts.speak("Veuillez remplir tous les champs.");
      }
      return;
    }

    setState(() {
      _showResults = true;
      _predictionMessage = "🤖 IA en cours d'analyse...";
      _isPredictionLoading = true;
    });

    _cardAnimationController.forward();

    if (_selectedLocation != null) {
      _animateToLocation(_selectedLocation!);
    }

    try {
      await Future.delayed(Duration(seconds: 3));

      final prediction = _simulateAIPrediction();

      setState(() {
        _selectedTrafficLevel = prediction['level'];
        _predictionMessage = "🚗 ${prediction['message']}";
        _isPredictionLoading = false;
      });

      // Speak the prediction result if voice is enabled
      if (_isVoiceEnabled) {
        await _flutterTts.speak(
          "Prédiction du trafic : ${_predictionMessage.replaceAll("🚗 ", "")}"
          " à ${_locationController.text} pour ${_dateController.text} à ${_timeController.text}.",
        );
      }

      _updateTrafficDataFromPrediction(prediction);

      // Calculate and display route if both current and selected locations are available
      if (_currentLocation != null &&
          _selectedLocation != null &&
          _currentLocation != _selectedLocation) {
        await _calculateRoute(_currentLocation!, _selectedLocation!);
      }

      _trafficOverlayController.forward();
    } catch (e) {
      print('Erreur de prédiction: $e');
      setState(() {
        _predictionMessage = "❌ Erreur de connexion à l'IA";
        _isPredictionLoading = false;
      });
      if (_isVoiceEnabled) {
        await _flutterTts.speak(
          "Erreur de connexion à l'intelligence artificielle.",
        );
      }
    }
  }

  Map<String, dynamic> _simulateAIPrediction() {
    final hour = int.tryParse(_timeController.text.split(':')[0]) ?? 9;
    final random = math.Random();

    if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      return {
        'level': 'Dense',
        'message': 'Trafic dense prévu (${15 + random.nextInt(10)} km/h)',
        'intensity': 0.8 + random.nextDouble() * 0.2,
        'color': Colors.red,
      };
    } else if (hour >= 22 || hour <= 6) {
      return {
        'level': 'Fluide',
        'message': 'Trafic fluide prévu (${50 + random.nextInt(20)} km/h)',
        'intensity': 0.1 + random.nextDouble() * 0.2,
        'color': Colors.green,
      };
    } else {
      return {
        'level': 'Modéré',
        'message': 'Trafic modéré prévu (${30 + random.nextInt(20)} km/h)',
        'intensity': 0.4 + random.nextDouble() * 0.3,
        'color': Colors.orange,
      };
    }
  }

  void _updateTrafficDataFromPrediction(Map<String, dynamic> prediction) {
    final intensity = prediction['intensity'] as double;
    final random = math.Random();

    _trafficData.clear();

    if (_selectedLocation != null) {
      for (int i = 0; i < 20; i++) {
        final lat =
            _selectedLocation!.latitude + (random.nextDouble() - 0.5) * 0.02;
        final lng =
            _selectedLocation!.longitude + (random.nextDouble() - 0.5) * 0.02;

        _trafficData.add(
          TrafficData(
            position: LatLng(lat, lng),
            intensity: intensity + (random.nextDouble() - 0.5) * 0.2,
            speed: 20 + (1 - intensity) * 50,
          ),
        );
      }
    }

    setState(() {});
  }

  Future<void> _calculateRoute(LatLng start, LatLng end) async {
    // Fixed API key declaration
    const apiKey =
        'd779ba1acdba7f5f23f1b664b0d7e20c'; // Replace with your actual OpenRouteService API key
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent': 'KAYYDRIVE-App/1.0 (danieleyoumbi@gmail.com)',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coordinates =
            data['features'][0]['geometry']['coordinates'] as List<dynamic>;

        final routePoints = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();

        setState(() {
          _trafficRoutes.add(
            TrafficRoute(
              points: routePoints,
              trafficLevelIdentifier: _getTrafficLevelFromPrediction(
                _selectedTrafficLevel,
              ),
            ),
          );
        });

        // Speak route information if voice is enabled
        if (_isVoiceEnabled) {
          await _flutterTts.speak(
            "Itinéraire calculé de votre position actuelle à ${_locationController.text}. "
            "Temps estimé : 12 minutes.",
          );
        }
      } else {
        print(
          'Erreur lors de la récupération de l\'itinéraire: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'itinéraire: $e');
    }
  }

  TrafficLevel _getTrafficLevelFromPrediction(String level) {
    switch (level) {
      case 'Fluide':
        return TrafficLevel.light;
      case 'Modéré':
        return TrafficLevel.moderate;
      case 'Dense':
        return TrafficLevel.heavy;
      default:
        return TrafficLevel.moderate;
    }
  }

  Future<List<Map<String, dynamic>>> _getLocationSuggestions(
    String query,
  ) async {
    if (query.isEmpty || query.length < 3) return [];

    if (query == "Position actuelle" ||
        query == "Recherche en cours..." ||
        query.contains("Permission de localisation")) {
      return [];
    }

    final encodedQuery = Uri.encodeComponent(query);
    final url =
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&addressdetails=1&limit=5&countrycodes=cm';

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent': 'KAYYDRIVE-App/1.0 (danieleyoumbi@gmail.com)',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          return [];
        }

        return data.map((result) {
          return {
            'display_name': result['display_name'] as String? ?? 'Inconnu',
            'lat': double.tryParse(result['lat'] as String? ?? '0') ?? 0.0,
            'lon': double.tryParse(result['lon'] as String? ?? '0') ?? 0.0,
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur de connexion lors de la récupération des suggestions: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);
    final Color primaryColor =
        Colors.red; // Variable pour la couleur principale
    final mapController = MapController();
    LatLng? userPosition;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      drawer: CustomDrawer(
        primaryColor: primaryColor,
        mapController: mapController,
        userPosition: userPosition,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPredictionForm(),
            SizedBox(height: 24),
            _buildEnhancedTrafficMap(),
            SizedBox(height: 16),
            if (_showResults)
              SlideTransition(
                position: _cardSlideAnimation,
                child: FadeTransition(
                  opacity: _cardOpacityAnimation,
                  child: _buildTrafficResults(),
                ),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFFE57373), size: 28),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '🤖 Prédiction IA Trafic',
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Color(0xFFE57373),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(
              _isVoiceEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isVoiceEnabled = !_isVoiceEnabled;
              });
              if (_isVoiceEnabled) {
                _flutterTts.speak("Assistant vocal activé.");
              } else {
                _flutterTts.speak("Assistant vocal désactivé.");
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Color(0xFFE57373), size: 24),
              SizedBox(width: 8),
              Text(
                'Configuration IA',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildLabel("📅 Date"),
          SizedBox(height: 8),
          _buildDateField(),
          SizedBox(height: 20),
          _buildLabel("⏰ Heure"),
          SizedBox(height: 8),
          _buildTimeField(),
          SizedBox(height: 20),
          _buildLabel("📍 Zone géographique"),
          SizedBox(height: 8),
          _buildLocationField(),
          SizedBox(height: 20),
          _buildLabel("🔊 Volume de l'assistant vocal"),
          SizedBox(height: 8),
          Slider(
            value: _ttsVolume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: _ttsVolume.toStringAsFixed(1),
            activeColor: Color(0xFFE57373),
            inactiveColor: Colors.grey[300],
            onChanged: (value) {
              _updateTtsVolume(value);
            },
          ),
          SizedBox(height: 24),
          _buildEnhancedPredictionButton(),
          if (_predictionMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _predictionMessage.contains("Erreur")
                      ? Colors.red.withOpacity(0.1)
                      : _isPredictionLoading
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _predictionMessage.contains("Erreur")
                        ? Colors.red.withOpacity(0.3)
                        : _isPredictionLoading
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    if (_isPredictionLoading)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        _predictionMessage,
                        style: TextStyle(
                          color: _predictionMessage.contains("Erreur")
                              ? Colors.red[700]
                              : _isPredictionLoading
                              ? Colors.blue[700]
                              : Colors.green[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedPredictionButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _buttonAnimationController.forward(),
            onTapUp: (_) {
              _buttonAnimationController.reverse();
              _predictTrafficWithAI();
            },
            onTapCancel: () => _buttonAnimationController.reverse(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE57373), Color(0xFFEF5350)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE57373).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.psychology, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Analyser avec IA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedTrafficMap() {
    final defaultLocation = LatLng(4.051056, 9.767868);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    _selectedLocation ?? _currentLocation ?? defaultLocation,
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                  _reverseGeocodeLocation(point.latitude, point.longitude);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.kayydrive',
                ),
                AnimatedBuilder(
                  animation: _trafficOpacityAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _trafficOpacityAnimation.value,
                      child: _buildTrafficOverlay(),
                    );
                  },
                ),
                if (_trafficRoutes.isNotEmpty)
                  PolylineLayer(
                    polylines: _trafficRoutes.map((route) {
                      return Polyline(
                        points: route.points,
                        strokeWidth: 6.0,
                        color: route.getColor().withOpacity(0.8),
                      );
                    }).toList(),
                  ),
                MarkerLayer(
                  markers: [
                    if (_currentLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentLocation!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    if (_selectedLocation != null &&
                        _selectedLocation != _currentLocation)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _selectedLocation!,
                        child: AnimatedBuilder(
                          animation: _mapAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale:
                                  1.0 + (_mapAnimationController.value * 0.3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE57373),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendItem(Colors.green, "Fluide"),
                    _buildLegendItem(Colors.orange, "Modéré"),
                    _buildLegendItem(Colors.red, "Dense"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficOverlay() {
    return CustomPaint(
      painter: TrafficHeatmapPainter(_trafficData),
      size: Size.infinite,
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _dateController.text.isEmpty
                    ? "Sélectionner une date"
                    : _dateController.text,
                style: TextStyle(
                  color: _dateController.text.isEmpty
                      ? Colors.grey[500]
                      : Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: Color(0xFFE57373), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _timeController.text,
              style: TextStyle(color: Color(0xFF333333), fontSize: 16),
            ),
            Icon(Icons.access_time, color: Color(0xFFE57373), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TypeAheadField<Map<String, dynamic>>(
      controller: _typeAheadController,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) {
            _locationController.text = value;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            filled: true,
            fillColor: Color(0xFFF8F8F8),
            hintText: "Tapez une adresse (ex. Douala, Cameroun)",
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon:
                controller.text.isNotEmpty &&
                    controller.text != "Recherche en cours..." &&
                    controller.text != "Position actuelle" &&
                    !controller.text.contains("Permission de localisation")
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      controller.clear();
                      _locationController.clear();
                      setState(() {
                        _selectedLocation = null;
                        _trafficData.clear();
                        _trafficRoutes.clear();
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.my_location, color: Color(0xFFE57373)),
                    onPressed: _getCurrentLocation,
                  ),
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty || pattern.length < 3) return [];
        return await _getLocationSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.location_on, color: Color(0xFFE57373)),
          title: Text(
            suggestion['display_name'],
            style: TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      onSelected: (suggestion) {
        _typeAheadController.text = suggestion['display_name'];
        _locationController.text = suggestion['display_name'];
        setState(() {
          _selectedLocation = LatLng(suggestion['lat'], suggestion['lon']);
        });
        _animateToLocation(_selectedLocation!);
      },
    );
  }

  Widget _buildTrafficResults() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFFE57373), size: 24),
              SizedBox(width: 8),
              Text(
                'Analyse IA du Trafic',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getTrafficLevelColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getTrafficLevelColor().withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getTrafficLevelColor(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Niveau prévu: $_selectedTrafficLevel',
                    style: TextStyle(
                      color: _getTrafficLevelColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            _predictionMessage,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          _buildTrafficStats(),
        ],
      ),
    );
  }

  Widget _buildTrafficStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Vitesse moy.", "35 km/h", Icons.speed)),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard("Temps estimé", "12 min", Icons.timer)),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard("Fiabilité", "85%", Icons.check_circle)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFFE57373), size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
        ],
      ),
    );
  }

  Color _getTrafficLevelColor() {
    switch (_selectedTrafficLevel) {
      case 'Fluide':
        return Colors.green;
      case 'Modéré':
        return Colors.orange;
      case 'Dense':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE57373),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE57373),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _reverseGeocodeLocation(double lat, double lon) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json';
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'User-Agent': 'KAYYDRIVE-App/1.0 (danieleyoumbi@gmail.com)',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _locationController.text =
              data['display_name'] ?? "Position sélectionnée";
          _typeAheadController.text =
              data['display_name'] ?? "Position sélectionnée";
        });
      }
    } catch (e) {
      print('Erreur de géocodage inverse: $e');
    }
  }
}

class TrafficData {
  final LatLng position;
  final double intensity;
  final double speed;

  TrafficData({
    required this.position,
    required this.intensity,
    required this.speed,
  });
}

class TrafficRoute {
  final List<LatLng> points;
  final TrafficLevel trafficLevelIdentifier;

  TrafficRoute({required this.points, required this.trafficLevelIdentifier});

  Color getColor() {
    switch (trafficLevelIdentifier) {
      case TrafficLevel.light:
        return Colors.green;
      case TrafficLevel.moderate:
        return Colors.orange;
      case TrafficLevel.heavy:
        return Colors.red;
    }
  }
}

enum TrafficLevel { light, moderate, heavy }

class TrafficHeatmapPainter extends CustomPainter {
  final List<TrafficData> trafficData;

  TrafficHeatmapPainter(this.trafficData);

  @override
  void paint(Canvas canvas, Size size) {
    for (final data in trafficData) {
      final paint = Paint()
        ..color = _getTrafficColor(data.intensity).withOpacity(0.6)
        ..style = PaintingStyle.fill;

      final radius = 20.0 * data.intensity;
      final center = Offset(
        size.width * 0.5 + (data.position.longitude - 9.767868) * 1000,
        size.height * 0.5 - (data.position.latitude - 4.051056) * 1000,
      );

      canvas.drawCircle(center, radius, paint);
    }
  }

  Color _getTrafficColor(double intensity) {
    if (intensity < 0.3) return Colors.green;
    if (intensity < 0.7) return Colors.orange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LiveTrafficIndicator extends StatefulWidget {
  final String location;
  final TrafficLevel currentLevel;

  const LiveTrafficIndicator({
    Key? key,
    required this.location,
    required this.currentLevel,
  }) : super(key: key);

  @override
  _LiveTrafficIndicatorState createState() => _LiveTrafficIndicatorState();
}

class _LiveTrafficIndicatorState extends State<LiveTrafficIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getTrafficColor(),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _getTrafficColor().withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.traffic, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  _getTrafficText(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTrafficColor() {
    switch (widget.currentLevel) {
      case TrafficLevel.light:
        return Colors.green;
      case TrafficLevel.moderate:
        return Colors.orange;
      case TrafficLevel.heavy:
        return Colors.red;
    }
  }

  String _getTrafficText() {
    switch (widget.currentLevel) {
      case TrafficLevel.light:
        return 'FLUIDE';
      case TrafficLevel.moderate:
        return 'MODÉRÉ';
      case TrafficLevel.heavy:
        return 'DENSE';
    }
  }
}
