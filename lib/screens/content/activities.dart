import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/layout/sidemenu.dart';
import 'package:adventour/components/media/media_slider.dart';
import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Activities extends StatefulWidget {
  final String countryCode;
  String? svg = "";
  Activities({super.key, required this.countryCode});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCountry(widget.countryCode).then((value) {
      setState(() {
        widget.svg = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContentAppbar(title: widget.countryCode),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Countries", style: Theme.of(context).textTheme.bodyLarge),
            countryslider(),
            Text(
              "Activities",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            MediaSlider(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  debugPrint("Explore button tapped on image");
                },
                child: const Text(
                  "Explore",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const SideMenu(),
    );
  }

  Future<String> fetchCountry(String countryCode) async {
    // if (countryCode.isEmpty) return;

    try {
      final result = await ApiService().get(
        '${Country.getCountry}/$countryCode',
        await FirebaseAuthService().getIdToken(),
        headers: <String, String>{},
        fromJsonT: (json) => CountryResponse.fromJson(json),
      );

      return result.data?.svg ?? "";
    } catch (e) {
      debugPrint("Error fetching country: $e");
    }

    return "";
  }

  Row countryslider() {
    return Row(
      children: [
        widget.svg != null && widget.svg!.isNotEmpty
            ? Container(
                width: 100,
                height: 100,
                child: SvgPicture.string(
                  widget.svg!,
                  fit: BoxFit.contain,
                ),
              )
            : Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade400,
                child: const Center(
                  child: const Text("No SVG"),
                ),
              ),
      ],
    );

    // return Row(
    //   children: [
    //     SizedBox(
    //       width: 100,
    //       height: 100,
    //       child: SimpleMap(
    //         fit: BoxFit.contain,
    //         countryBorder: const CountryBorder(
    //           color: Colors.black,
    //           width: 0.5,
    //         ),
    //         instructions: SMapPortugal.instructions,
    //         defaultColor: Colors.grey.shade400,
    //         callback: (id, name, tapDetails) async {
    //           debugPrint("Tapped on: $name ($id)");
    //         },
    //       ),
    //     ),
    //     SizedBox(
    //       width: 100,
    //       height: 100,
    //       child: SimpleMap(
    //         fit: BoxFit.contain,
    //         countryBorder: const CountryBorder(
    //           color: Colors.black,
    //           width: 0.5,
    //         ),
    //         instructions: SMapAngola.instructions,
    //         defaultColor: Colors.grey.shade400,
    //         callback: (id, name, tapDetails) async {
    //           debugPrint("Tapped on: $name ($id)");
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
