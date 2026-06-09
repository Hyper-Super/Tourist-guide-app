import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String id;
  final String name;
  final String city;
  final String country;
  final String imageUrl;
  final String description;
  final double rating;
  final double latitude;
  final double longitude;

  const Destination({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });

  factory Destination.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Destination(
      id: doc.id,
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'city': city,
      'country': country,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
