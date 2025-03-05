import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
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
  String selectedCountryName = "";
  String selectedCountryContinent = "";
  String fetchedData = "";
  ErrorService errorService = ErrorService();

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
              if (selectedCountryName.isNotEmpty) ...displayFetchedData(),
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

  Future<void> fetchCountry(String countryCode) async {
    if (countryCode.isEmpty) return;

    try {
      final result = await ApiService().get(
        '${Country.getCountry}/$countryCode',
        await FirebaseAuthService().getFirebaseIdToken(),
        headers: <String, String>{},
        fromJsonT: (json) => CountryResponse.fromJson(json),
      );

      if (result.success) {
        setState(() {
          selectedCountryName =
              (result.data?.name ?? '').isEmpty ? '' : result.data!.name;
          selectedCountryContinent = (result.data?.continent ?? '').isEmpty
              ? ''
              : result.data!.continent;
        });
      } else {
        // ignore: use_build_context_synchronously
        errorService.displaySnackbarError(context, result.message);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorService.displaySnackbarError(context, null);
    }
  }
}
