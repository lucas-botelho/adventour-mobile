import 'package:flutter/material.dart';

class AttractionNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const AttractionNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const List<String> labels = ["About", "Information", "Reviews"];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Ensure even spacing
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            // Distribute space evenly
            child: Center(
              child: TextButton(
                onPressed: () => onTabSelected(index),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: isSelected ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
