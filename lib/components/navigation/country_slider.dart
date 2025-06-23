import 'package:adventour/global_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/respositories/map_respository.dart';
import 'package:provider/provider.dart';

class CountrySlider extends StatefulWidget {
  final String countryCode;
  final Function(String) onCountryChanged; // Callback for country change

  const CountrySlider({
    super.key,
    required this.countryCode,
    required this.onCountryChanged,
  });

  @override
  State<CountrySlider> createState() => _CountrySliderState();
}

class _CountrySliderState extends State<CountrySlider> {
  late final MapRepository mapRespository;
  CountryResponse? currentCountry;
  List<CountryResponse> countries = [];
  int myCurrentIndex = 0;
  int currentPage = 1;
  int currentPreviousPage = -1;
  final int pageSize = 5;
  bool isLoading = false;
  int totalCountries = 0;
  late final GlobalAppState globalState;

  @override
  void initState() {
    super.initState();
    mapRespository = context.read<MapRepository>();
    _initCountries();
    globalState = context.read<GlobalAppState>();
  }

  void _onCountrySelected(int index) {
    setState(() {
      currentCountry = countries[index];
      globalState.setCountryIsoCode(currentCountry!.code);
    });

    debugPrint("Selected country: ${currentCountry!.name}"); // Debug log

    // Trigger the callback to notify the parent widget
    widget.onCountryChanged(currentCountry!.code);
  }

  Future<void> _initCountries() async {
    setState(() => isLoading = true);

    try {
      final currentCountryResponse =
          await mapRespository.getCountry(widget.countryCode);
      currentCountry = currentCountryResponse?.data;

      if (currentCountry != null) {
        var prevCountriesResponse = await mapRespository.getCountries(
            currentCountry!.continent, currentPreviousPage, widget.countryCode);

        var previousCountries = prevCountriesResponse?.data?.countries ?? [];

        var nextCountries = (await mapRespository.getCountries(
                    currentCountry!.continent, currentPage, widget.countryCode))
                ?.data
                ?.countries ??
            [];

        setState(() {
          countries = [...previousCountries, currentCountry!, ...nextCountries];
          myCurrentIndex = previousCountries.length;
          totalCountries = prevCountriesResponse?.data?.totalCountries ?? 0;
          currentPreviousPage--;
          currentPage++;
        });
      }
    } catch (e) {
      debugPrint("Error fetching countries: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<List<CountryResponse>> _fetchCountries(bool loadNext) async {
    if (isLoading || countries.length == totalCountries) return [];

    setState(() => isLoading = true);

    try {
      int pageToLoad = loadNext ? currentPage : currentPreviousPage;

      var response = await mapRespository.getCountries(
        currentCountry!.continent,
        pageToLoad,
        widget.countryCode,
      );

      if (loadNext) {
        currentPage++;
      } else {
        currentPreviousPage--;
      }

      return response?.data?.countries ?? [];
    } catch (e) {
      debugPrint("Error fetching more countries: $e");
      return [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: countries.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CarouselSlider.builder(
              itemCount: countries.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () =>
                      _onCountrySelected(index), // Handle country selection
                  child: _buildCountryItem(index),
                );
              },
              options: CarouselOptions(
                initialPage: myCurrentIndex,
                height: MediaQuery.of(context).size.height,
                enableInfiniteScroll: false,
                autoPlay: false,
                viewportFraction: 0.22,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) async {
                  setState(() {
                    myCurrentIndex = index;
                  });

                  if (index >= countries.length - (pageSize / 4) &&
                      !isLoading) {
                    var newCountries = await _fetchCountries(true);
                    if (newCountries.isNotEmpty) {
                      setState(() {
                        countries.addAll(newCountries);
                      });
                    }
                  } else if (index <= pageSize / 4 && !isLoading) {
                    var newCountries = await _fetchCountries(false);
                    if (newCountries.isNotEmpty) {
                      setState(() {
                        countries.insertAll(0, newCountries);
                        myCurrentIndex += newCountries.length;
                      });
                    }
                  }
                },
              ),
            ),
    );
  }

  Widget _buildCountryItem(int index) {
    var country = countries[index];
    bool isSelected = currentCountry?.code == country.code;

    return GestureDetector(
      onTap: () => _onCountrySelected(index),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelected ? 1.0 : 0.5,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: isSelected ? 70 : 60,
                height: isSelected ? 75 : 65,
                child: SvgPicture.string(
                  country.svg,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                country.name,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
