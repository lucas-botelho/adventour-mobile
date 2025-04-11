import 'package:adventour/respositories/map_respository.dart';
import 'package:adventour/screens/content/country_attractions.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/components/cta/cta_button.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';

class AdventourMap extends StatefulWidget {
  const AdventourMap({super.key});

  @override
  State<AdventourMap> createState() => _AdventourMapState();
}

class _AdventourMapState extends State<AdventourMap> {
  String country = "";
  String continent = "";
  String countryIsoCode = "";
  String fetchedData = "";
  ErrorService errorService = ErrorService();
  final mapRepository = MapRespository();

  @override
  void initState() {
    super.initState();
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
              styledHeader(),
              styledMap(),
              if (country.isNotEmpty) ...displayFetchedData(),
              styledCTAButton(),
            ],
          ),
        ),
      ),
    );
  }

  Padding styledHeader() {
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

  SizedBox styledMap() {
    return SizedBox(
      height: 500,
      width: double.infinity, // Define largura total do ecrã
      child: InteractiveViewer(
        constrained: true,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 20.0,
        child: Center(
          child: Container(
            constraints:
                const BoxConstraints(maxWidth: 1200), // Limita o tamanho máximo
            child: SimpleMap(
              fit: BoxFit.contain,
              countryBorder: const CountryBorder(
                color: Colors.black,
                width: 0.5,
              ),
              instructions: SMapWorld.instructionsMercator,
              defaultColor: Colors.grey.shade400,
              callback: (id, name, tapDetails) async {
                await fetchCountry(id);
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding styledCTAButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: CTAButton(
          text: "Explore",
          onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountryAttractions(
                      continentName: continent,
                      countryCode: countryIsoCode,
                    ),
                  ),
                )
              }),
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
      Text(continent),
      _textDivider(),
      Text(country),
    ];
  }

  Future<void> fetchCountry(String countryCode) async {
    if (countryCode.isEmpty) return;

    countryIsoCode = countryCode;

    try {
      var result = await mapRepository.getCountryData(countryCode);
      if (result != null) {
        if (result.success) {
          setState(() {
            country =
                (result.data?.name ?? '').isEmpty ? '' : result.data!.name;
            continent = (result.data?.continent ?? '').isEmpty
                ? ''
                : result.data!.continent;
          });
        } else {
          // ignore: use_build_context_synchronously
          errorService.displaySnackbarError(context, result.message);
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }
  }
}
