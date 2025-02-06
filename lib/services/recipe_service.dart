import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference _recipesCollection =
  FirebaseFirestore.instance.collection('recipes');

  Future<List<Recipe>> searchRecipes(List<String> ingredients) async {
    try {
      final querySnapshot = await _recipesCollection
          .where('ingredients', arrayContainsAny: ingredients)
          .get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _recipesCollection.add(recipe.toMap());
  }

  Future<void> toggleFavorite(String recipeId, String userId) async {
    final docRef = _recipesCollection.doc(recipeId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);
      if (!docSnapshot.exists) return;

      final recipe = Recipe.fromDocument(docSnapshot);
      final favorites = List<String>.from(recipe.favoriteBy);

      if (favorites.contains(userId)) {
        favorites.remove(userId);
      } else {
        favorites.add(userId);
      }

      transaction.update(docRef, {'favoriteBy': favorites});
    });
  }

  Stream<List<Recipe>> getUserFavorites(String userId) {
    return _recipesCollection
        .where('favoriteBy', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Recipe.fromDocument(doc)).toList());
  }
}