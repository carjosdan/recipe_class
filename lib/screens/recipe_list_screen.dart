import 'package:flutter/material.dart';
import 'package:recetario_clase/models/category.dart';
import 'package:recetario_clase/models/recipe.dart';
import 'package:recetario_clase/screens/recipe_detail_screen.dart';
import 'package:recetario_clase/services/recipe_service.dart';
import 'package:recetario_clase/styles/app_styles.dart';
import 'package:recetario_clase/widgets/recipe_card.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final Set<Recipe> favorites = {};
  String query = '';
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  List<Recipe> apiRecipes = [];
  bool isLoading = false;
  Category? selectedCategory;
  late Future<List<Category>> categoriesFuture;
  final recipeService = RecipeService();

  void toggleFavorite(Recipe recipe) {
    if (favorites.contains(recipe)) {
      favorites.remove(recipe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Has sacado ${recipe.title} de'
            'los favoritos',
          ),
          persist: false,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              favorites.add(recipe);
              setState(() {});
            },
          ),
        ),
      );
    } else {
      favorites.add(recipe);
    }
    setState(() {});
  }

  void clearSearch() {
    searchController.clear();
    query = '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadRecipes();
    categoriesFuture = loadCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openRecipe(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  Future<void> confirmClearFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quitar de favoritos'),
        content: Text('Seguro que quiere borrar los favoritos'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('CONFIRMAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('CANCELAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      favorites.clear();
      setState(() {});
    }
    debugPrint('$confirmed');
  }

  Future<void> loadRecipes() async {
    isLoading = true;
    setState(() {});
    try {
      apiRecipes = await recipeService.getRecipes(
        query,
        selectedCategory?.id ?? "",
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se ha encontrado recetas'),
          action: SnackBarAction(label: 'Reintentar', onPressed: () {}),
        ),
      );
    }
    isLoading = false;
    setState(() {});
  }

  Future<List<Category>> loadCategories() async {
    try {
      return await recipeService.getCategories();
    } catch (e) {
      if (!mounted) return [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No s'han pogut carregar les categories"),
          action: SnackBarAction(
            label: "Reintentar",
            onPressed: loadCategories,
          ),
        ),
      );
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final List<Recipe> filteredRecipes = selectedIndex == 0
        ? apiRecipes.toList()
        : favorites.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Recetario"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              alignment: .center,
              children: [
                Icon(Icons.favorite, size: 40),
                Text('${favorites.length}', style: AppStyles.favoriteText),
              ],
            ),
          ),
          if (selectedIndex == 1 && favorites.isNotEmpty)
            IconButton(
              onPressed: confirmClearFavorites,
              icon: Icon(Icons.delete, size: 40),
            ),
        ],
      ),
      body: Column(
        children: [
          if (selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: searchController,
                onChanged: (value) async {
                  query = value;
                },
                onSubmitted: (value) async {
                  await loadRecipes();
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Busca una receta',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: clearSearch,
                        ),
                ),
              ),
            ),
          SizedBox(
            height: 48,
            child: FutureBuilder<List<Category>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("No se han cargado las categorías"),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final categories = snapshot.data!;
                if (categories.isEmpty) {
                  return Text("No hay categorías");
                }
                return ListView.builder(
                  scrollDirection: .horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        selected: selectedCategory == category,
                        onSelected: (isSelected) async {
                          if (isSelected) {
                            selectedCategory = category;
                          } else {
                            selectedCategory = null;
                          }
                          await loadRecipes();
                          setState(() {});
                        },
                        label: Text(categories[index].name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredRecipes.isEmpty
                ? Center(child: Text("No s'han trobat receptes"))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                    ),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];

                      return RecipeCard(
                        recipe: recipe,
                        isFavorite: favorites.contains(recipe),
                        onFavoritePressed: () => toggleFavorite(recipe),
                        onTap: () {
                          openRecipe(recipe);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          selectedIndex = value;
          setState(() {});
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Todas'),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
