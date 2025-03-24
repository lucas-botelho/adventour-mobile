import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MediaSlider extends StatefulWidget {
  final Function(int)
      onIndexChanged; // Callback to inform parent of index change

  const MediaSlider({super.key, required this.onIndexChanged});

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
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: imagePaths.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                debugPrint("Tapped on image $index");
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: DecorationImage(
                        image: AssetImage(imagePaths[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint("Heart icon tapped on image $index");
                      },
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.35,
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
              widget.onIndexChanged(index); // Notify parent
            },
          ),
        ),
      ],
    );
  }
}
