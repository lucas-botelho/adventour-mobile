import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/respositories/map_respository.dart';

class CountrySlider extends StatefulWidget {
  const CountrySlider({
    super.key,
    required this.countryCode,
  });

  final String countryCode;

  @override
  State<CountrySlider> createState() => _CountrySliderState();
}

class _CountrySliderState extends State<CountrySlider> {
  final MapRespository mapRespository = MapRespository();
  CountryResponse? currentCountry;
  List<CountryResponse> countries = [];
  int myCurrentIndex = 0;
  int currentPage = 1;
  int currentPreviousPage = -1;
  final int pageSize = 5;
  bool isLoading = false;
  int totalCountries = 0;

  @override
  void initState() {
    super.initState();
    _initCountries();
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
                return _buildCountryItem(index);
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
      onTap: () => {debugPrint},
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
