import 'dart:collection';
import 'dart:convert';
import 'package:final_project_pantrypal/domain/custom_text_style.dart';
import 'package:final_project_pantrypal/screen/recipes_details_screen.dart';
import 'package:final_project_pantrypal/screen/add_new_recipe_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/recipes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. Define a Future variable to hold the API call result
  late Future<RecipesDataModel?> _recipesFuture;

  // 5. LOCAL CACHE: List to hold recipes added by the user during this session
  final List<Recipes> _userAddedRecipes = [];

  @override
  void initState() {
    super.initState();
    // 2. Initialize the future only once here (fixes infinite loop)
    _recipesFuture = hitRecipesApi();
  }

  // Helper function to re-fetch data (for refreshing after adding a recipe)
  void _refreshRecipes() {
    setState(() {
      _recipesFuture = hitRecipesApi();
      // Note: We don't need to add the new recipe here; it's added below.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "KitchenCraft",
          style: myTextStyle24(
              textFamily: "secondary",
              textColor: Colors.brown),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/cook-book.png"),
        ),
        actions: const [
          Icon(Icons.notifications , size: 30,),
          SizedBox(width: 8,)
        ],
        centerTitle: true,
        shadowColor: Colors.black12,
        elevation: 11,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),

        backgroundColor: Colors.orangeAccent.shade200,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("Most Loved Recipes", style: myTextStyle18()),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: FutureBuilder<RecipesDataModel?>( // Use the explicit type
                  future: _recipesFuture, // 3. Use the initialized Future
                  builder: (context, snapshot) {
                    // 3. Fix the connection state check
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error Found : ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData && snapshot.data!.recipes != null) {

                      // 6. Combine API recipes with locally added recipes
                      final apiRecipes = snapshot.data!.recipes!;
                      final List<Recipes> combinedRecipes = [...apiRecipes, ..._userAddedRecipes];

                      if (combinedRecipes.isEmpty) {
                        return const Center(child: Text("No recipes found."));
                      }

                      return GridView.builder(
                        itemCount: combinedRecipes.length,

                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          final recipe = combinedRecipes[index]; // Use the combined list
                          return Card(
                            elevation: 3,
                            shadowColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///image
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            recipe.image ?? 'https://placehold.co/600x400/FFCC80/000?text=No+Image',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  ///name
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      recipe.name ?? 'Unknown Recipe',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: myTextStyle12(
                                        textColor: Colors.brown,
                                        textWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Calories : ",
                                          style: myTextStyle18(
                                            textColor: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "${recipe.caloriesPerServing}",
                                          style: myTextStyle18(
                                            textColor: Colors.black,
                                            textWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///_____________VIEW BUTTON__________________///
                                        ///when click on this button navigation to the details screen
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigation is using old field-by-field parameters.
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipesDetailsScreen(
                                                          imageSrc: recipe.image.toString(),
                                                          title: recipe.name.toString(),
                                                          calories:recipe.caloriesPerServing.toString() ,
                                                          cookTime:recipe.cookTimeMinutes.toString() ,
                                                          difficultLevel:recipe.difficulty.toString() ,
                                                          foodType:recipe.mealType.toString() ,
                                                          prepTime:recipe.prepTimeMinutes.toString() ,
                                                          rating:recipe.rating.toString() ,
                                                          revCount:recipe.reviewCount.toString() ,
                                                          cuisine: recipe.cuisine.toString(),
                                                          ingredientsList: recipe.ingredients ?? [],
                                                          instructionsList: recipe.instructions ?? [],

                                                        )));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                21,
                                              ),
                                            ),
                                            backgroundColor:
                                            Colors.orangeAccent.shade200,
                                            foregroundColor: Colors.brown,
                                          ),

                                          child: Text(
                                            "View",
                                            style: myTextStyle24(
                                              textColor: Colors.brown,
                                              textWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${recipe.cookTimeMinutes} min",
                                          style: myTextStyle18(
                                            textColor: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // --- FLOATING ACTION BUTTON IMPLEMENTATION (The + button) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          ).then((newRecipe) {
            // 7. Check if a Recipe object was returned from the AddRecipeScreen
            if (newRecipe is Recipes) {
              setState(() {
                _userAddedRecipes.add(newRecipe);
              });
            }
            _refreshRecipes(); // Call refresh in case the API data needs updating
          });
        },
        backgroundColor: Colors.orangeAccent.shade200,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  ///______________________________API FUNCTION________________________________///
  Future<RecipesDataModel?> hitRecipesApi() async {
    String url = "https://dummyjson.com/recipes";
    Uri uri = Uri.parse(url);
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
      var resData = jsonDecode(res.body);
      return RecipesDataModel.fromJson(resData);
    } else {
      return null;
    }
  }
}
