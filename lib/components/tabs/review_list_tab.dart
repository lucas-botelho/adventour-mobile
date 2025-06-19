import 'package:adventour/models/responses/attraction/attraction_reviews_response.dart';
import 'package:adventour/models/responses/attraction/review_with_image_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewListTab extends StatefulWidget {
  final int attractionId;
  final VoidCallback onButtonPress;

  const ReviewListTab({
    super.key,
    required this.attractionId,
    required this.onButtonPress,
  });

  @override
  State<ReviewListTab> createState() => _ReviewListTabState();
}

class _ReviewListTabState extends State<ReviewListTab> {
  bool isLoading = true;
  String? defaultMessage =
      'We don\'t have any reviews yet.\nBe the first to write one!';
  AttractionReviewsResponse? attractionReviews;
  late final AttractionRepository attractionRepository;

  @override
  void initState() {
    super.initState();
    attractionRepository = context.read<AttractionRepository>();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await attractionRepository.getReviews(
          attractionId: widget.attractionId);

      if (response == null ||
          response.data == null ||
          response.success == false) {
        return;
      }

      setState(() {
        attractionReviews = response.data;
      });
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildRatingSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Opinions of the Adventurers",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.ramabhadra().fontFamily),
        ),
        const SizedBox(height: 8),
        Text(
          "See what other people are saying about the adventure",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.ramabhadra().fontFamily),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width ,
          child: Row(
            children: [
              Text('Average rating: ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: GoogleFonts.manuale().fontFamily)),
              ...List.generate(
                  attractionReviews?.averageRating.round() ?? 0,
                  (index) =>
                      const Icon(Icons.star, color: Colors.amber, size: 32)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Column(
            children: [
              _buildRatingBar(
                  "Excellent", attractionReviews?.fiveStarCount() ?? 0),
              _buildRatingBar(
                  "Very good", attractionReviews?.fourStarCount() ?? 0),
              _buildRatingBar(
                  "Average", attractionReviews?.threeStarCount() ?? 0),
              _buildRatingBar("Poor", attractionReviews?.twoStarCount() ?? 0),
              _buildRatingBar(
                  "Terrible", attractionReviews?.oneStarCount() ?? 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(String label, int count) {
    int total = attractionReviews?.reviews.length ?? 0;

    double? progressValue = 0;
    if (total > 0) {
      final normalized = count / total;
      if (normalized.isFinite && !normalized.isNaN) {
        progressValue = normalized;
      }
    }

    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(label,
              style: TextStyle(
                  fontFamily: GoogleFonts.manuale().fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w800)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count.toString(),
          style: TextStyle(
              fontFamily: GoogleFonts.manuale().fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.w800),
        ),
      ],
    );
  }


  Widget _buildReviewCard(ReviewWithImagesResponse review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              review.data.person.photoUrl.isEmpty
                  ? CircleAvatar(
                      child: Text(
                        review.data.person.username[0].toUpperCase(),
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(review.data.person.photoUrl),
                      radius: 20,
                    ),
              const SizedBox(width: 10),
              Text(
                "@${review.data.person.username}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // const Spacer(),
              //   IconButton(
              //   icon: const Icon(Icons.thumb_up_alt_outlined),
              //   onPressed: () {},
              // ),
              // IconButton(
              //   icon: const Icon(Icons.more_vert),
              //   onPressed: () {},
              // ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(
                  review.data.rating.value,
                  (index) =>
                      const Icon(Icons.star, color: Colors.amber, size: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review.data.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(review.data.comment),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingSummary(),
                if (attractionReviews == null ||
                    attractionReviews!.reviews.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        defaultMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Column(
                    children: attractionReviews!.reviews
                        .map((review) => _buildReviewCard(review))
                        .toList(),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.6, // 3/5 of screen width
                    child: ElevatedButton(
                      onPressed: widget.onButtonPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Write a review",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Averia Libre',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          height: 22 / 13,
                          // line-height
                          letterSpacing: 0.05 * 13, // 5%
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
