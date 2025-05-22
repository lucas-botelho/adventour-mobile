import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/navigation/navbar.dart';
import 'package:adventour/models/responses/attraction/favorited_attraction.dart';
import 'package:adventour/models/responses/attraction/favorites_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:adventour/services/error_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late final AttractionRepository attractionRepository;
  late final ErrorService errorService;
  FavoritesResponse? favorites;
  bool isLoading = true;
  String search = '';

  @override
  void initState() {
    super.initState();
    attractionRepository = context.read<AttractionRepository>();
    errorService = context.read<ErrorService>();
    fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = favorites?.attractions
            .where((f) => f.name.toLowerCase().contains(search.toLowerCase()))
            .toList() ??
        [];

    return Scaffold(
      appBar: const ContentAppbar(title: "Favorites"),
      bottomNavigationBar: const NavBar(selectedIndex: 3),
      backgroundColor: const Color(0xFF0F4C4C),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "View and Manage Your Favorite\nAdventures",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Averia Libre',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setState(() => search = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final fav = filtered[index];
                          return _buildFavoriteCard(fav);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFavoriteCard(FavoritedAttractionDetails fav) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: fav.imageUrl.isEmpty
                  ? const Center(
                child: Icon(Icons.image, size: 40, color: Colors.white),
              )
                  : Image.network(
                fav.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fav.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Averia Libre',
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          fav.averageRating.round(),
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        fav.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fav.countryName,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              removeFromFavorite(fav.id);
            },
          ),
        ],
      ),
    );
  }

  void removeFromFavorite(int id) async {
    final response = await attractionRepository.removeFromFavorite(id);
    if (response?.success ?? false) {
      setState(() {
        favorites?.attractions.removeWhere((fav) => fav.id == id);
      });
    } else {
      errorService.displaySnackbarError(context, "Failed to remove favorites");
    }
  }

  void fetchFavorites() async {
    try {
      final response = await attractionRepository.getFavorites();
      if (response != null && response.data != null) {
        setState(() {
          favorites = response.data!;
          isLoading = false;
        });
      } else {
        errorService.displaySnackbarError(context, "Failed to fetch favorites");
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }
  }
}
