import 'package:adventour/components/form/review_form_tab.dart';
import 'package:adventour/components/tabs/review_list_tab.dart';
import 'package:flutter/material.dart';

class ReviewTabs extends StatefulWidget {
  final int attractionId;

  const ReviewTabs({super.key, required this.attractionId});

  @override
  State<ReviewTabs> createState() => _ReviewTabsState();
}

class _ReviewTabsState extends State<ReviewTabs> with TickerProviderStateMixin {
  int currentIndex = 0;

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
    return Expanded(
      child: IndexedStack(
        index: currentIndex,
        children: [
          ReviewListTab(
              attractionId: widget.attractionId,
              onButtonPress: () {
                setState(() {
                  currentIndex = 1;
                });
              }),
          ReviewFormTab(attractionId: widget.attractionId, callback: () {
            setState(() {
              currentIndex = 0;
            });
          }),
        ],
      ),
    );
  }
}
