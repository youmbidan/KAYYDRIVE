import 'package:flutter/material.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls = [
    'https://picsum.photos/300/200?random=1',
    'https://picsum.photos/300/200?random=2',
    'https://picsum.photos/300/200?random=3',
    'https://picsum.photos/300/200?random=4',
    'https://picsum.photos/300/200?random=5',
  ];

  ImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Hauteur fixe pour la galerie
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Défilement horizontal
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrls[index],
                width: 300, // Largeur fixe pour chaque image
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 300,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 300,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
