import 'package:http/http.dart' as http;
import 'package:recetario_clase/models/category.dart';
import 'package:recetario_clase/models/category_list.dart';
import 'package:recetario_clase/models/recipe.dart';
import 'package:recetario_clase/models/recipe_detail.dart';
import 'package:recetario_clase/models/recipe_list.dart';

class RecipeService {
  final baseUrl = 'https://xupxup.poquesoft.net';

  Future<String> getBody(String path) async {
    final http.Response response = await http.get(
      Uri.parse('https://xupxup.poquesoft.net/$path'),
    );
    return response.body;
  }

  Future<List<Recipe>> getRecipes(String query, String? category) async {
    final body = await getBody('recipes?search=$query&category=$category');
    return recipeListFromJson(body).recipes;
  }

  Future<List<Category>> getCategories() async {
    final body = await getBody('categories');
    return categoryListFromJson(body).categories;
  }

  Future<RecipeDetail> getRecipe(int i) async {
    final body = await getBody('recipes/$i');
    return recipeDetailFromJson(body);
  }
}
