import 'package:adventour/components/form/review_form_tab.dart';
import 'package:adventour/components/tabs/review_list_tab.dart';
import 'package:flutter/material.dart';

class ReviewTabs extends StatefulWidget {
  final int attractionId;
  final void Function(bool reviewCreated) callback;


  const ReviewTabs({super.key, required this.attractionId, required this.callback});

  @override
  State<ReviewTabs> createState() => _ReviewTabsState();
}

class _ReviewTabsState extends State<ReviewTabs> with TickerProviderStateMixin {
  int currentIndex = 0;
  bool refreshReviews = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        ReviewListTab(
          attractionId: widget.attractionId,
          onButtonPress: () {
            setState(() {
              currentIndex = 1;
            }); //needs to be passed on constructor to change the index stack as a callback
          },
        ),
        ReviewFormTab(
          attractionId: widget.attractionId,
          callback: (bool reviewCreated) {
            setState(() {
              currentIndex = 0;
            });

            widget.callback(reviewCreated);
          },
        ),
      ],
    );
  }
}
