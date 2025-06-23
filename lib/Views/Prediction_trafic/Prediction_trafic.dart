import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';

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

  late AnimationController _buttonAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardOpacityAnimation;

  String _selectedTrafficLevel = "Modéré";
  bool _showResults = false;

  @override
  void initState() {
    super.initState();

    // Initialiser les valeurs par défaut
    _timeController.text = "09:00";
    _locationController.text = "Latitude, Longitude, adresse";

    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
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
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _cardAnimationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Color(0xFFE57373), size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Prédiction du trafic',
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
              icon: Icon(Icons.person_outline, color: Colors.white, size: 24),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulaire de prédiction
            _buildPredictionForm(),

            SizedBox(height: 24),

            // Carte du trafic
            _buildTrafficMap(),

            SizedBox(height: 16),

            // Résultats de prédiction
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
          // Date
          _buildLabel("Date"),
          SizedBox(height: 8),
          _buildDateField(),

          SizedBox(height: 20),

          // Heure
          _buildLabel("Heure"),
          SizedBox(height: 8),
          _buildTimeField(),

          SizedBox(height: 20),

          // Zone géographique
          _buildLabel("Zone géographique"),
          SizedBox(height: 8),
          _buildLocationField(),

          SizedBox(height: 24),

          // Bouton de prédiction
          _buildPredictionButton(),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: _locationController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Latitude, Longitude, adresse",
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        style: TextStyle(color: Color(0xFF333333), fontSize: 16),
      ),
    );
  }

  Widget _buildPredictionButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _buttonAnimationController.forward(),
            onTapUp: (_) {
              _buttonAnimationController.reverse();
              _predictTraffic();
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
              child: Text(
                'Prévoir le trafic',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrafficMap() {
    return Container(
      height: 200,
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
        child: CustomPaint(painter: TrafficMapPainter(), size: Size.infinite),
      ),
    );
  }

  Widget _buildTrafficResults() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
                Text(
                  'Trafic Moyen',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  _selectedTrafficLevel,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
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
                Text(
                  'État du trajet (h)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 16),
                _buildTrafficChart(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrafficChart() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildChartBar(0.3, "6h"),
          _buildChartBar(0.2, "8h"),
          _buildChartBar(0.8, "12h"),
          _buildChartBar(1.0, "18h"),
          _buildChartBar(0.6, "22h"),
        ],
      ),
    );
  }

  Widget _buildChartBar(double height, String label) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 20,
                height: height * 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFAB91), Color(0xFFFF7043)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? Color(0xFFE57373) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey[600],
            size: 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xFFE57373) : Colors.grey[600],
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
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
    if (picked != null) {
      setState(() {
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _predictTraffic() {
    if (kIsWeb) {
      // Logique spécifique au web (Edge)
      print('Traffic prediction activated on web platform');

      setState(() {
        _showResults = true;
        // Simuler différents niveaux de trafic
        List<String> trafficLevels = [
          "Faible",
          "Modéré",
          "Dense",
          "Très dense",
        ];
        _selectedTrafficLevel = trafficLevels[DateTime.now().millisecond % 4];
      });

      _cardAnimationController.forward();
    } else {
      // Ne pas exécuter sur l'émulateur
      return;
    }
  }
}

class TrafficMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Dessiner les routes avec différentes couleurs selon le trafic
    final routes = [
      // Routes principales (rouge - trafic dense)
      {
        'color': Color(0xFFE57373),
        'points': [
          Offset(size.width * 0.1, size.height * 0.3),
          Offset(size.width * 0.4, size.height * 0.3),
          Offset(size.width * 0.6, size.height * 0.5),
          Offset(size.width * 0.9, size.height * 0.5),
        ],
      },
      {
        'color': Color(0xFFE57373),
        'points': [
          Offset(size.width * 0.2, size.height * 0.1),
          Offset(size.width * 0.2, size.height * 0.9),
        ],
      },

      // Routes secondaires (orange - trafic modéré)
      {
        'color': Color(0xFFFF7043),
        'points': [
          Offset(size.width * 0.0, size.height * 0.6),
          Offset(size.width * 0.5, size.height * 0.6),
          Offset(size.width * 0.7, size.height * 0.8),
        ],
      },
      {
        'color': Color(0xFFFF7043),
        'points': [
          Offset(size.width * 0.5, size.height * 0.2),
          Offset(size.width * 0.8, size.height * 0.2),
          Offset(size.width * 0.8, size.height * 0.7),
        ],
      },

      // Routes fluides (vert - trafic faible)
      {
        'color': Color(0xFF66BB6A),
        'points': [
          Offset(size.width * 0.0, size.height * 0.8),
          Offset(size.width * 0.3, size.height * 0.8),
          Offset(size.width * 0.5, size.height * 0.9),
        ],
      },
      {
        'color': Color(0xFF66BB6A),
        'points': [
          Offset(size.width * 0.6, size.height * 0.1),
          Offset(size.width * 0.9, size.height * 0.3),
        ],
      },
    ];

    for (var route in routes) {
      paint.color = route['color'] as Color;
      final points = route['points'] as List<Offset>;

      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    // Ajouter quelques zones d'intérêt
    final pointPaint = Paint()..style = PaintingStyle.fill;

    // Points d'intérêt
    pointPaint.color = Color(0xFF2196F3);
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.4),
      4,
      pointPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.6),
      4,
      pointPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      4,
      pointPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
