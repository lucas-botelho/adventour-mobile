import 'dart:convert';

import 'package:adventour/components/cta/cta_button.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:http/http.dart' as http;

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  String selectedCountry = ""; // Default text
  String fetchedData = ""; // Data to hold the fetched result

  late Future<String> text;

  @override
  void initState() {
    super.initState();
    text = fetchText();
  }

  Future<String> fetchText() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/Authentication/test'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final data = jsonDecode(response.body);
      setState(() {
        fetchedData =
            data['data'] ?? 'No data'; // Assign the value of "data" field
      });
      return data['message'] ?? 'No message';
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4D4B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              _titleText(),
              _map(),
              if (selectedCountry.isNotEmpty) ...[
                Text(
                  'Fetched Data: $fetchedData',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(selectedCountry),
                _textDivider(),
                Text(
                  selectedCountry,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
              _exploreCTAButton(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _titleText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "Explore the world and choose\nwhere you want to go on your next\nadventure!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox _map() {
    return SizedBox(
      height: 500,
      child: InteractiveViewer(
        constrained: true,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 20.0,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: SimpleMap(
              fit: BoxFit.contain,
              countryBorder: const CountryBorder(
                color: Colors.black,
                width: 0.5,
              ),
              instructions: SMapWorld.instructions,
              defaultColor: Colors.grey.shade400,
              callback: (id, name, tapDetails) {
                setState(() {
                  selectedCountry = id;
                });
                // print('Selected country: $name ($id)');
                // Handle country selection here
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding _exploreCTAButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: CTAButton(
        text: "Explore",
        onPressed: () => {print("Explore")},
      ),
    );
  }

  Padding _textDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 1,
        width: 250,
        color: Colors.white,
      ),
    );
  }
}
