import 'package:adventour/global_state.dart';
import 'package:adventour/screens/auth/account_settings.dart';
import 'package:adventour/screens/content/country_attractions.dart';
import 'package:adventour/screens/content/favorites_screen.dart';
import 'package:adventour/screens/content/itenerary.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;

  const NavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final String continentName = context.watch<GlobalAppState>().continentName;
    final String countryIsoCode = context.watch<GlobalAppState>().countryIsoCode;
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 190, 246, 251),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            label: 'Country',
            index: 0,
            icon: Icons.location_on,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CountryAttractions(
                  continentName: continentName,
                  countryCode: countryIsoCode,
                ),
              ),
            ),
          ),
          _buildNavItem(
            label: 'Planner',
            index: 1,
            icon: Icons.explore,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItineraryPlanner(
                  countryCode: countryIsoCode,
                ),
              ),
            ),
          ),
          _buildNavItem(
            label: 'Map',
            index: 2,
            icon: Icons.public,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdventourMap(),
              ),
            ),
          ),
          _buildNavItem(
            label: 'Favorites',
            index: 3,
            icon: Icons.favorite,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Favorites(),
              ),
            ),
          ),
          _buildNavItem(
            label: 'Settings',
            index: 4,
            icon: Icons.settings,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountSettings(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onItemTapped,
  }) {
    final bool isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: isSelected ? null : onItemTapped,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
