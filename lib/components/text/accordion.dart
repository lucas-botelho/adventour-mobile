import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;
  final String description;

  const Accordion({super.key, required this.title, required this.description});

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                fontFamily: 'Poppins',
                color: Color(0xFF686868),
              ),
            ),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                textAlign: TextAlign.justify,
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Color(0xFF686868),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
