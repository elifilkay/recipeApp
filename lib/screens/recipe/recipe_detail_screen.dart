// lib/screens/recipe/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final RecipeService _recipeService = RecipeService();

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          if (user != null)
            IconButton(
              icon: Icon(
                recipe.favoriteBy.contains(user.uid)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () => _recipeService.toggleFavorite(recipe.id, user.uid),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imageUrl.isNotEmpty)
              Image.network(
                recipe.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarif Açıklaması',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(recipe.description),
                  SizedBox(height: 16),
                  Text(
                    'Malzemeler',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ...recipe.ingredients.map(
                        (ingredient) => ListTile(
                      leading: Icon(Icons.circle),
                      title: Text(ingredient),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Hazırlanışı',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ...recipe.steps.asMap().entries.map(
                        (entry) => ListTile(
                      leading: CircleAvatar(
                        child: Text('${entry.key + 1}'),
                      ),
                      title: Text(entry.value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}