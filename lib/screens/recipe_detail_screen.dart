import 'package:flutter/material.dart';
import 'package:recetario_clase/models/recipe_detail.dart';
import 'package:recetario_clase/services/recipe_service.dart';
import 'package:recetario_clase/styles/app_styles.dart';
import 'package:recetario_clase/widgets/cooking_timer.dart';
import 'package:recetario_clase/widgets/icon_text.dart';

import '../models/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<RecipeDetail> recipeFuture;
  final recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    recipeFuture = loadRecipeDetail();
  }

  Future<RecipeDetail> loadRecipeDetail() async {
    return recipeService.getRecipe(widget.recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recetario")),
      body: FutureBuilder(
        future: recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error cargando la receta'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final RecipeDetail recipeDetail = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.recipe.imageUrl,
                      height: 250,
                      width: .infinity,
                      fit: .cover,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppStyles.imageShade,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Text(
                        widget.recipe.title,
                        style: AppStyles.mainTitle,
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyles.tagBackground,
                          borderRadius: .circular(16),
                        ),
                        child: Text(widget.recipe.category),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: .all(16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          IconText(
                            icon: Icons.timer_outlined,
                            text: '${widget.recipe.minutes} min',
                          ),
                          IconText(
                            icon: Icons.people_outline,
                            text: '${widget.recipe.servings} personas',
                          ),
                        ],
                      ),
                      AppStyles.bigSeparator,
                      CookingTimer(minutes: widget.recipe.minutes),
                      AppStyles.mediumSeparator,
                      Text("Ingredientes", style: AppStyles.sectionTitle),
                      AppStyles.smallSeparator,
                      for (final ingredient in recipeDetail.ingredients)
                        Text("$ingredient"),
                      AppStyles.mediumSeparator,
                      Text("Preparación", style: AppStyles.sectionTitle),
                      AppStyles.smallSeparator,
                      for (var i = 0; i < recipeDetail.steps.length; i++)
                        Text("${i + 1}. ${recipeDetail.steps[i]}"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
