import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/navigation/country_slider.dart';
import 'package:adventour/components/navigation/navbar.dart';
import 'package:adventour/components/navigation/sidemenu.dart';
import 'package:adventour/components/media/media_slider.dart';
import 'package:flutter/material.dart';

class CountryAttractions extends StatefulWidget {
  final String countryCode;
  final String continentName;

  const CountryAttractions(
      {super.key, required this.countryCode, required this.continentName});

  @override
  State<CountryAttractions> createState() => _CountryAttractionsState();
}

class _CountryAttractionsState extends State<CountryAttractions> {
  late String selectedCountryCode; // Store the selected country code

  @override
  void initState() {
    super.initState();
    selectedCountryCode =
        widget.countryCode; // Initialize with the initial country code
  }

  void _onCountryChanged(String newCountryCode) {
    setState(() {
      selectedCountryCode = newCountryCode; // Update the selected country code
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContentAppbar(title: widget.continentName),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Countries", style: Theme.of(context).textTheme.bodyLarge),
            CountrySlider(
              countryCode: selectedCountryCode,
              onCountryChanged: _onCountryChanged, // Pass the callback
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("Activities",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            MediaSlider(
                countryCode: selectedCountryCode),
          ],
        ),
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: const NavBar(selectedIndex: 0),
    );
  }
}
