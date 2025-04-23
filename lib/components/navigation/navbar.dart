import 'package:adventour/screens/auth/account_settings.dart';
import 'package:adventour/screens/content/attraction.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 190, 246, 251),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(30),
        //   topRight: Radius.circular(30),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.explore,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttractionDetails(
                  attractionId: 1,
                ),
              ),
            ),
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.public,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdventourMap(),
              ),
            ),
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.favorite,
            onItemTapped: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Favorites(),
              ),
            ),
          ),
           _buildNavItem(
            index: 3,
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

  Widget _buildNavItem(
      {required int index,
      required IconData icon,
      required VoidCallback onItemTapped}) {
    final bool isSelected = widget.selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      padding: const EdgeInsets.all(5),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.teal.shade800,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade900,
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            )
          : const BoxDecoration(),
      child: IconButton(
        icon: Icon(
          icon,
          size: 42,
          color: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: isSelected ? null : onItemTapped,
        splashRadius: 30, // Optional: customize splash effect size
      ),
    );
  }
}

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

