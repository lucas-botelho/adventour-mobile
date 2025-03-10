import 'package:flutter/material.dart';
import 'package:adventour/components/navigation/custom_bottom_nav_bar.dart';

class CountryActivities extends StatefulWidget {
  const CountryActivities({super.key});

  @override
  State<CountryActivities> createState() => _CountryActivitiesState();
}

class _CountryActivitiesState extends State<CountryActivities> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation or actions based on the selected index
    switch (index) {
      case 0:
        // Handle location button tap
        break;
      case 1:
        // Handle explore button tap
        break;
      case 2:
        // Handle globe button tap
        break;
      case 3:
        // Handle favorites button tap
        break;
      case 4:
        // Handle settings button tap
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              'Country Activities Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}
