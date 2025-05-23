import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';
import 'package:flutter/material.dart';

class ItineraryHeaderImage extends StatelessWidget {
  const ItineraryHeaderImage({
    super.key,
    required this.attractions,
    required this.context,
    required double headerHeightFactor,
  }) : _headerHeightFactor = headerHeightFactor;

  final List<BasicAttractionResponse> attractions;
  final BuildContext context;
  final double _headerHeightFactor;

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (attractions.isNotEmpty &&
        attractions.first.attractionImages.isNotEmpty) {
      imageUrl = attractions.first.attractionImages.first.url;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * _headerHeightFactor,
      width: double.infinity,
      child: imageUrl != null
          ? Image.network(imageUrl, fit: BoxFit.cover)
          : Image.asset('assets/images/step_two_image.jpg', fit: BoxFit.cover),
    );
  }
}