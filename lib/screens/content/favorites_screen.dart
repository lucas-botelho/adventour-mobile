import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/navigation/navbar.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late final AttractionRepository attractionRepository;

  List<Map<String, dynamic>> favorites = [
    {
      'id': 1,
      'image':
          'https://res.cloudinary.com/dgskluspn/image/upload/v1739805925/1000000033.jpg',
      'title': 'Iron Train Mauritania',
      'rating': 5.0,
    },
    {
      'id': 2,
      'image':
          'https://res.cloudinary.com/dgskluspn/image/upload/v1744702589/33.jpg',
      'title': 'Climbing Mount\nKilimanjaro, Tanzania',
      'rating': 4.5,
    },
  ];

  String search = '';

  @override
  void initState() {
    super.initState();

    attractionRepository = context.read<AttractionRepository>();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = favorites
        .where((f) => f['title'].toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: const ContentAppbar(title: "Favorites"),
      bottomNavigationBar: const NavBar(selectedIndex: 2),
      backgroundColor: const Color(0xFF0F4C4C),
      body: SafeArea(
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

  Widget _buildFavoriteCard(Map<String, dynamic> fav) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              fav['image'],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
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
                    fav['title'],
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
                          fav['rating'].round(),
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        fav['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => removeFromFavorite(fav['id']),
          ),
        ],
      ),
    );
  }

  void removeFromFavorite(int id) async {
    setState(() {
      favorites.removeWhere((fav) => fav['id'] == id);
    });

    final response = await attractionRepository.removeFromFavorite(id);
    if (response?.success ?? false) {
      setState(() {
        favorites.removeWhere((fav) => fav['id'] == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove favorite")),
      );
    }
  }
}
