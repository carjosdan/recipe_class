import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../styles/app_styles.dart' show AppStyles;
import '../widgets/icon_text.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Recetario'),
        backgroundColor: AppStyles.primary,
        foregroundColor: AppStyles.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Image.network(recipe.imageUrl,
              height: 200,
              width: .infinity,
              fit: .cover,
            ),
            Padding(
              padding: .all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title,
                    style: AppStyles.sectionTitle,
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      IconText(icon: Icons.timer_outlined, text: '30 min'),
                     // Icon(Icons.timer_outlined),
                     // Text(' 30 min'),
                      IconText(icon: Icons.people_outlined, text: ' 4 personas'),
                      Container(
                        padding: .symmetric(horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppStyles.secondary,
                          borderRadius: .circular(16.0),
                        ),
                        child: Text(recipe.category),
                      )
                    ],
                  ),
                  AppStyles.sectionSpacingExtraLarge,
                  Text('Ingredientes',
                    style: AppStyles.sectionTitle,
                  ),
                  AppStyles.sectionSpacingLarge,
                  for (final ingredient in recipe.ingredients) 
                    Text('• $ingredient',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  AppStyles.sectionSpacingExtraLarge,
                  Text('Preparación',
                    style: AppStyles.sectionTitle,
                  ),
                  AppStyles.sectionSpacingLarge,
                  for (var i = 0; i < recipe.steps.length; i++) 
                    Text('${i + 1}. ${recipe.steps[i]}',
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