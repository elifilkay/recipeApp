import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes_app/services/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RecipeApp());  // 'const' eklenmiş
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});  // 'const' eklenmiş

  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // 'const' eklenmiş
      title: 'Tarif Bulucu',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  AuthenticationWrapper(),  // Burada AuthenticationWrapper kullanılıyor
    );
  }
}
