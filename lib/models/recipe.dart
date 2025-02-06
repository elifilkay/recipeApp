// lib/models/recipe.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final String userId;
  final List<String> favoriteBy;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.userId,
    required this.favoriteBy,
  });

  factory Recipe.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      userId: data['userId'] ?? '',
      favoriteBy: List<String>.from(data['favoriteBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'imageUrl': imageUrl,
      'userId': userId,
      'favoriteBy': favoriteBy,
    };
  }
}