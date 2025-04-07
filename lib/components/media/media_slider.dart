import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MediaSlider extends StatefulWidget {
  const MediaSlider({super.key});

  @override
  State<MediaSlider> createState() => _MediaSliderState();
}

class _MediaSliderState extends State<MediaSlider> {
  final List<String> imagePaths = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/1.jpg',
  ];

  int myCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildImageCarousel(),
          Positioned(bottom: 0, child: _buildExploreButton()),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider.builder(
      itemCount: imagePaths.length,
      itemBuilder: (context, index, realIndex) {
        return _buildCarouselItem(index);
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.25,
        enableInfiniteScroll: true,
        autoPlay: false,
        viewportFraction: 0.65,
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
    return GestureDetector(
      onTap: () => debugPrint("Tapped on image $index"),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildImageContainer(index),
          _buildHeartIcon(index),
        ],
      ),
    );
  }

  Widget _buildImageContainer(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        image: DecorationImage(
          image: AssetImage(imagePaths[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeartIcon(int index) {
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () => debugPrint("Heart icon tapped on image $index"),
        child: const Icon(
          Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return ElevatedButton(
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
    );
  }
}
