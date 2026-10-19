import 'package:flutter/material.dart';
import 'screens/recipe_detail_screen.dart';
import 'models/recipe.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key}); 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lexend',
      ),
      home: RecipeDetailScreen(recipe: arrabiata),
    );

  }
}
