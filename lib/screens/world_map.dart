import 'dart:convert';
import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/settings/constants.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:http/http.dart' as http;

class CustomMap extends StatefulWidget {
  const CustomMap({super.key, required String userId, required token});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class CountryModel {
  final String name;
  final String continent;
  final int id;

  CountryModel({required this.name, required this.continent, required this.id});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      continent: json['continentName'],
      id: json['id'],
    );
  }
}

class _CustomMapState extends State<CustomMap> {
  String selectedCountryName = "";
  String selectedCountryContinent = "";
  String fetchedData = "";

  late Future<CountryModel> text;

  @override
  void initState() {
    super.initState();
  }

  Future<CountryModel?> fetchCountry(String countryCode) async {
    final response = await http.get(Uri.parse(
        '${AppSettings.apiBaseUrl}/${Country.GetCountry}/$countryCode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Pass `CountryModel.fromJson` as the converter function
      final BaseApiResponse<CountryModel> result =
          BaseApiResponse<CountryModel>.fromJson(
              data, (json) => CountryModel.fromJson(json));

      return result.data;
    } else {
      //TODO: Handle error when user clicks on the water
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
              _customMap(),
              if (selectedCountryName.isNotEmpty) ...displayFetchedData(),
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

  SizedBox _customMap() {
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
              callback: (id, name, tapDetails) async {
                CountryModel? country = await fetchCountry(id);

                if (country != null) {
                  setState(() {
                    selectedCountryName = country.name;
                    selectedCountryContinent = country.continent;
                  });
                }
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

  List<Widget> displayFetchedData() {
    return [
      Text(selectedCountryContinent),
      _textDivider(),
      Text(selectedCountryName),
    ];
  }
}
