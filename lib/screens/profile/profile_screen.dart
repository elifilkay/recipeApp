// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/recipe.dart';
import '../../services/storage_service.dart';
import '../recipe/recipe_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final StorageService _storageService = StorageService();

  Future<void> _updateProfilePhoto() async {
    if (user == null) return;

    final imageUrl = await _storageService.uploadImage(
      'profile_photos/${user!.uid}.jpg',
    );

    if (imageUrl != null) {
      await user!.updatePhotoURL(imageUrl);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _updateProfilePhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recipes')
                  .where('favoriteBy', arrayContains: user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final recipes = snapshot.data!.docs
                    .map((doc) => Recipe.fromDocument(doc))
                    .toList();

                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return ListTile(
                      leading: recipe.imageUrl.isNotEmpty
                          ? Image.network(recipe.imageUrl)
                          : Icon(Icons.food_bank),
                      title: Text(recipe.title),
                      subtitle: Text(recipe.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}