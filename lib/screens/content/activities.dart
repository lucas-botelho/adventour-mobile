import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/layout/sidemenu.dart';
import 'package:adventour/components/media/media_slider.dart';
import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/respositories/map_respository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Activities extends StatefulWidget {
  final String countryCode;
  final String continentName;

  const Activities(
      {super.key, required this.countryCode, required this.continentName});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  String? svg;
  int page = 1;
  int currentMediaIndex = 0;
  List<CountryResponse> countries = [];

  final List<String> imagePaths = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      var countriesResult =
          await MapRespository().getCountries(widget.continentName, 1);
      var country = await MapRespository().getCountry(widget.countryCode);

      setState(() {
        svg = country?.data?.svg ?? "";
        countries = countriesResult?.data!.countries ?? [];
      });
    } catch (e) {
      debugPrint("Error fetching country: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContentAppbar(title: widget.countryCode),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Countries", style: Theme.of(context).textTheme.bodyLarge),
            _buildCountrySlider(),
            const SizedBox(height: 10),
            Text("Activities", style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  MediaSlider(
                    onIndexChanged: (index) {
                      setState(() {
                        currentMediaIndex = index;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      debugPrint(
                          "Explore button tapped on: ${imagePaths[currentMediaIndex]}");
                    },
                    child: const Text(
                      "Explore",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const SideMenu(),
    );
  }

  Widget _buildCountrySlider() {
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
                  child: Text("No SVG"),
                ),
              ),
      ],
    );
  }
}
