import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 190, 246, 251),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.location_on,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.explore,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.public,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.favorite,
          ),
          _buildNavItem(
            index: 4,
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
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
                color: Colors.teal.shade900.withOpacity(0.6),
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
      onPressed: () => widget.onItemTapped(index),
      splashRadius: 30, // Optional: customize splash effect size
    ),
  );
}

}