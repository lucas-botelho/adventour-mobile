import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/layout/sidemenu.dart';
import 'package:adventour/components/media/media_slider.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';

class Activities extends StatefulWidget {
  final String countryCode;

  const Activities({super.key, required this.countryCode});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
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

  Row countryslider() {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: SimpleMap(
            fit: BoxFit.contain,
            countryBorder: const CountryBorder(
              color: Colors.black,
              width: 0.5,
            ),
            instructions: SMapPortugal.instructions,
            defaultColor: Colors.grey.shade400,
            callback: (id, name, tapDetails) async {
              debugPrint("Tapped on: $name ($id)");
            },
          ),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: SimpleMap(
            fit: BoxFit.contain,
            countryBorder: const CountryBorder(
              color: Colors.black,
              width: 0.5,
            ),
            instructions: SMapAngola.instructions,
            defaultColor: Colors.grey.shade400,
            callback: (id, name, tapDetails) async {
              debugPrint("Tapped on: $name ($id)");
            },
          ),
        ),
      ],
    );
  }
}
