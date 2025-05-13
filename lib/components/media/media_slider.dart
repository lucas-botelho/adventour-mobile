import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:adventour/screens/content/attraction.dart';
import 'package:adventour/services/error_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttractionSlider extends StatefulWidget {
  final String countryCode;

  const AttractionSlider({super.key, required this.countryCode});

  @override
  State<AttractionSlider> createState() => _AttractionSliderState();
}

class _AttractionSliderState extends State<AttractionSlider> {
  List<BasicAttractionResponse?> attractions = [];
  int myCurrentIndex = 0;
  bool isLoading = true; // Track loading state
  Set<int> favoriteAttractions = {}; // Track favorite attractions
  late String currentCountryCode;

  late final AttractionRepository attractionRepository;
  late final ErrorService errorService;


    @override
  void initState() {
    super.initState();
    currentCountryCode =
        widget.countryCode; // Initialize with the initial country code
    attractionRepository = context.read<AttractionRepository>();
    errorService = context.read<ErrorService>();

    _fetchAttractions(); // Fetch attractions for the initial country

  }

  @override
  void didUpdateWidget(covariant AttractionSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryCode != widget.countryCode) {
      // Country code has changed, update state and fetch new data
      setState(() {
        myCurrentIndex = 0; // Reset index to 0
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
        onTap: () => toggleFavorite(index),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttractionDetails(
              attractionId: attractions[myCurrentIndex]!.id,
            ),
          ),
        ),
        child: const Text(
          "Explore",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> _fetchAttractions() async {
    try {
      final response = await attractionRepository.getAttractions(
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

  void toggleFavorite(int index) {
    if (favoriteAttractions.contains(attractions[index]!.id)) {
      removeFromFavorite(index);
    } else {
      addToFavorite(index);
    }
  }

  void addToFavorite(int index) async {
    final attraction = attractions[index];
    if (attraction == null) return;

    final response = await attractionRepository.addToFavorite(attraction.id);

    if (response?.success ?? false) {
      setState(() {
        favoriteAttractions.add(attraction.id); // Mark as favorite
      });
    } else {
      errorService.displaySnackbarError(context,  "Failed to add ${attraction.name} to favorites. Please try again later.");
    }
  }

  void removeFromFavorite(int index) async {
    final attraction = attractions[index];
    if (attraction == null) return;

    final response =
        await attractionRepository.removeFromFavorite(attraction.id);

    if (response?.success ?? false) {
      setState(() {
        favoriteAttractions.remove(attraction.id); // Remove from favorites
      });
    } else {
      errorService.displaySnackbarError(context,  "Failed to remove ${attraction.name} from favorites. Please try again later.");
    }
  }
}
