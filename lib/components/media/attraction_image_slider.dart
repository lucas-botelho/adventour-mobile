import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AttractionImageSlider extends StatefulWidget {
  final List<String> imageUrls; // List of image URLs

  const AttractionImageSlider({super.key, required this.imageUrls});

  @override
  State<AttractionImageSlider> createState() => _AttractionImageSliderState();
}

class _AttractionImageSliderState extends State<AttractionImageSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const Center(
        child: Text("No images available."),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index, realIndex) {
            return _buildImageItem(index);
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.35,
            enableInfiniteScroll: true,
            autoPlay: false,
            viewportFraction: 0.55,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        widget.imageUrls[index],
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  // Widget _buildIndicator() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: widget.imageUrls.asMap().entries.map((entry) {
  //       return GestureDetector(
  //         onTap: () => setState(() {
  //           currentIndex = entry.key;
  //         }),
  //         child: Container(
  //           width: 8.0,
  //           height: 8.0,
  //           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color:
  //                 currentIndex == entry.key ? Colors.blueAccent : Colors.grey,
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}
