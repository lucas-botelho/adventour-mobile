import 'package:flutter/material.dart';

class ReviewListTab extends StatelessWidget {
  final int attractionId;
  final VoidCallback onButtonPress;
  const ReviewListTab({super.key, required this.attractionId, required this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    // Aqui colocas a lógica para buscar reviews via Provider, FutureBuilder, etc.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("Opinions of the Adventurers", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        // Simulação de uma review
        Card(
          child: ListTile(
            leading: CircleAvatar(child: Text("A")),
            title: Text("Mauritania Iron Train"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("⭐️⭐️⭐️⭐️⭐️"),
                Text("One of the craziest experiences I've ever had!"),
              ],
            ),
            trailing: Icon(Icons.thumb_up_alt_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: onButtonPress,
            child: const Text("Write a Review"),
          ),
        )
        // Repetir para outras reviews
      ],
    );
  }
}
