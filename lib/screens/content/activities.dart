import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/layout/sidemenu.dart';
import 'package:adventour/components/media/media_slider.dart';
import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/respositories/map_respository.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Activities extends StatefulWidget {
  final String countryCode;
  final String continentName;
  final int page = 1;
  Activities(
      {super.key, required this.countryCode, required this.continentName});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  String? svg = "";

  @override
  void initState() {
    super.initState();
    fetchCountry(widget.countryCode).then((value) {
      setState(() {
        svg = value;
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
      var result = await MapRespository().getCountry(countryCode);

      return result?.data?.svg ?? "";
    } catch (e) {
      debugPrint("Error fetching country: $e");
    }

    return "";
  }

  Row countryslider() {
    return Row(
      children: [
        svg != null && svg!.isNotEmpty
            ? Container(
                width: 100,
                height: 100,
                child: SvgPicture.string(
                  svg!,
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
  }
}
