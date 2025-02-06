// lib/screens/recipe/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/recipe.dart';
import '../../services/storage_service.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _steps = [];
  String? _imageUrl;

  final StorageService _storageService = StorageService();

  Future<void> _uploadImage() async {
    final imageUrl = await _storageService.uploadImage(
      'recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    if (imageUrl != null) {
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final recipe = Recipe(
      id: '',
      title: _titleController.text,
      description: _descriptionController.text,
      ingredients: _ingredients,
      steps: _steps,
      imageUrl: _imageUrl ?? '',
      userId: user.uid,
      favoriteBy: [],
    );

    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .add(recipe.toMap());

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarif kaydedilemedi: $e')),
      );
    }
  }

  Future<String?> _showTextInputDialog(String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yeni Tarif Ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            GestureDetector(
              onTap: _uploadImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageUrl != null
                    ? Image.network(_imageUrl!, fit: BoxFit.cover)
                    : Icon(Icons.add_photo_alternate, size: 50),
              ),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Tarif Adı'),
              validator: (value) =>
              value?.isEmpty ?? true ? 'Tarif adı gerekli' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Tarif Açıklaması'),
              maxLines: 3,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Tarif açıklaması gerekli' : null,
            ),
            SizedBox(height: 16),
            Text('Malzemeler', style: Theme.of(context).textTheme.titleLarge),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _ingredients.length + 1,
              itemBuilder: (context, index) {
                if (index == _ingredients.length) {
                  return ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Malzeme Ekle'),
                    onTap: () async {
                      final ingredient = await _showTextInputDialog('Malzeme');
                      if (ingredient != null && ingredient.isNotEmpty) {
                        setState(() {
                          _ingredients.add(ingredient);
                        });
                      }
                    },
                  );
                }
                return ListTile(
                  title: Text(_ingredients[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _ingredients.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Text('Hazırlanış Adımları', style: Theme.of(context).textTheme.titleLarge),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _steps.length + 1,
              itemBuilder: (context, index) {
                if (index == _steps.length) {
                  return ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Adım Ekle'),
                    onTap: () async {
                      final step = await _showTextInputDialog('Hazırlanış Adımı');
                      if (step != null && step.isNotEmpty) {
                        setState(() {
                          _steps.add(step);
                        });
                      }
                    },
                  );
                }
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(_steps[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _steps.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: Text('Tarifi Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}