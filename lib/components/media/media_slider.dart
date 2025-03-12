import 'package:flutter/material.dart';

class MediaSlider extends StatefulWidget {
  const MediaSlider({super.key});

  @override
  _MediaSliderState createState() => _MediaSliderState();
}

class _MediaSliderState extends State<MediaSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sliderHeight = MediaQuery.of(context).size.height * 0.45;
    final sliderWidth = MediaQuery.of(context).size.width * 0.8;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: sliderHeight,
          width: double.infinity,
          child: buildPageView(sliderHeight, sliderWidth),
        );
      },
    );
  }

  Widget buildPageView(double sliderHeight, double sliderWidth) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 10,
      itemBuilder: (context, index) {
        return buildAnimatedBuilder(sliderHeight, sliderWidth, index);
      },
    );
  }

  Widget buildAnimatedBuilder(
      double sliderHeight, double sliderWidth, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        } else {
          value = index == _pageController.initialPage
              ? 1.0
              : 0.7; // Initial scaling
        }
        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * sliderHeight,
            width: Curves.easeOut.transform(value) * sliderWidth,
            child: child,
          ),
        );
      },
      child: buildPageContent(index),
    );
  }

  Widget buildPageContent(int index) {
    return GestureDetector(
      onTap: () {
        debugPrint("Tapped on image $index");
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          buildImageContainer(),
          buildHeartIcon(index),
        ],
      ),
    );
  }

  Widget buildImageContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 10), // Adjust the margin to control spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/images/login_image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildHeartIcon(int index) {
    return Positioned(
      top: 10,
      left: 10,
      child: GestureDetector(
        onTap: () {
          debugPrint("Heart icon tapped on image $index");
        },
        child: const Icon(
          Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}
