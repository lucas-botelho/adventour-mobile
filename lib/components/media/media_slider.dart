import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MediaSlider extends StatefulWidget {
  final String countryCode;

  const MediaSlider({super.key, required this.countryCode});

  @override
  State<MediaSlider> createState() => _MediaSliderState();
}

class _MediaSliderState extends State<MediaSlider> {
  List<BasicAttractionResponse?> attractions = [];
  final AttractionRespository attractionRespository = AttractionRespository();
  int myCurrentIndex = 0;
  bool isLoading = true; // Track loading state
  Set<int> favoriteAttractions = {}; // Track favorite attractions
  late String currentCountryCode;

  @override
  void initState() {
    super.initState();
    currentCountryCode =
        widget.countryCode; // Initialize with the initial country code
    _fetchAttractions(); // Fetch attractions for the initial country
  }

  @override
  void didUpdateWidget(covariant MediaSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryCode != widget.countryCode) {
      // Country code has changed, update state and fetch new data
      setState(() {
        currentCountryCode = widget.countryCode;
      });
      _fetchAttractions();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Show loader while loading
      );
    }

    if (attractions.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No attractions found."),
        ),
      );
    }

    final currentAttraction = attractions[myCurrentIndex]!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildImageCarousel(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  currentAttraction.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  currentAttraction.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _buildExploreButton(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider.builder(
      itemCount: attractions.length,
      itemBuilder: (context, index, realIndex) {
        return _buildCarouselItem(index);
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.45,
        enableInfiniteScroll: true,
        autoPlay: false,
        viewportFraction: 0.70,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        onPageChanged: (index, reason) {
          setState(() {
            myCurrentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCarouselItem(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildImageContainer(index),
        _buildHeartIcon(index),
      ],
    );
  }

  Widget _buildImageContainer(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Image.network(
          attractions[index]!.attractionImages[0].url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildHeartIcon(int index) {
    final attraction = attractions[index];
    final isFavorite = favoriteAttractions.contains(attraction!.id);

    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () => addToFavorite(index),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.white,
        ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return Positioned(
      bottom: 0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: () =>
            debugPrint("Explore button tapped on index: $myCurrentIndex"),
        child: const Text(
          "Explore",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> _fetchAttractions() async {
    setState(() => isLoading = true); // Start loading

    try {
      final response = await attractionRespository.getAttractions(
        countryCode: currentCountryCode,
      );

      if (response != null && response.data != null) {
        setState(() {
          attractions = response.data!.attractions;
          favoriteAttractions = response.data!.attractions
              .where((attraction) => attraction.isFavorited)
              .map((attraction) => attraction.id)
              .toSet();
        });
      } else {
        debugPrint(
            "No attractions found for country code: $currentCountryCode");
      }
    } catch (e) {
      debugPrint("Error fetching attractions: $e");
    } finally {
      setState(() => isLoading = false); // Stop loading
    }
  }

  void addToFavorite(int index) async {
    final attraction = attractions[index];
    if (attraction == null) return;

    final response = await attractionRespository.addToFavorite(attraction.id);

    if (response?.success ?? false) {
      setState(() {
        favoriteAttractions.add(attraction.id); // Mark as favorite
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Failed to add ${attraction.name} to favorites. Please try again later.")),
      );
    }
  }
}
