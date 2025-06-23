import 'package:flutter/material.dart';

// Classe helper pour les items de navigation
class NavItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  NavItem({required this.icon, required this.label, this.onTap});
}

class CustomBottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<NavItem> visibleItems;
  final List<NavItem> hiddenItems;

  const CustomBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.visibleItems,
    required this.hiddenItems,
  }) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _expanded ? 135 : 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flèche de contrôle
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Center(
                child: Container(
                  width: 30,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.grey.shade600,
                    size: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),

            // Première ligne de boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.visibleItems.asMap().entries.map((entry) {
                return _buildNavButton(entry.key, entry.value);
              }).toList(),
            ),

            // Deuxième ligne (si étendu)
            if (_expanded) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.hiddenItems.asMap().entries.map((entry) {
                  return _buildNavButton(
                    entry.key + widget.visibleItems.length,
                    entry.value,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(int index, NavItem item) {
    final isSelected = widget.selectedIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        widget.onItemTapped(index);
        // Exécuter l'action personnalisée si elle existe
        item.onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? primaryColor : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(height: 1),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey.shade600,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
