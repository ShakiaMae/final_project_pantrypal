import 'package:final_project_pantrypal/model/recipes_model.dart';
import 'package:flutter/material.dart';
// 1. ADD THIS IMPORT: Import the recipe model for structured data handling

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Form Key and Controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _caloriesController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  // --- SAVE RECIPE FUNCTION (Mock Integration) ---
  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Start mock saving process
      setState(() {
        _isSaving = true;
      });

      // 2. CREATE A RECIPE OBJECT HERE
      final newRecipe = Recipes(
        name: _nameController.text,
        cookTimeMinutes: int.tryParse(_timeController.text) ?? 0,
        caloriesPerServing: int.tryParse(_caloriesController.text) ?? 0,
        // The rest of the fields are populated from defaults or simple parsing
        difficulty: 'Medium',
        mealType: ['Dinner'],
        prepTimeMinutes: 10,
        rating: 4.0,
        reviewCount: 0,
        cuisine: 'Mixed',
        ingredients: _ingredientsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        instructions: _instructionsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        image: 'https://placehold.co/600x400/FFCC80/000?text=MOCK+RECIPE',
      );

      // --- MOCK SAVE IMPLEMENTATION ---
      try {
        await Future.delayed(const Duration(seconds: 1));

        // In a real application, you would pass this 'newRecipe' object to a
        // data service or local database for persistence.

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe "${newRecipe.name}" saved (Mock)!'), backgroundColor: Colors.green),
        );

        // Clear form and navigate back
        _nameController.clear();
        _timeController.clear();
        _caloriesController.clear();
        _ingredientsController.clear();
        _instructionsController.clear();
        Navigator.of(context).pop();

      } catch (e) {
        // Mock failure handling
        print("Mock Save Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save recipe (Mock Error).'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. Define the button widget as a simple FloatingActionButton
    final Widget _saveRecipeButton = FloatingActionButton(
      onPressed: _isSaving ? null : _saveRecipe,
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 8,
      // If saving, show a spinner, otherwise show the + icon
      child: _isSaving
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : const Icon(Icons.add),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Name Field ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  hintText: 'e.g., Spicy Chicken Stir Fry',
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Cooking Time Field ---
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Cooking Time (Minutes)',
                  hintText: 'e.g., 30',
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid number of minutes.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Calories Field ---
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories Per Serving',
                  hintText: 'e.g., 450',
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid calorie count.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text("Enter each item on a new line.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),

              // --- Ingredients Field (Multi-line) ---
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients',
                  hintText: '1 cup flour\n2 eggs\n...',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one ingredient.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Instructions Field (Multi-line) ---
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  hintText: 'Step 1: Prep vegetables\nStep 2: Cook meat\n...',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cooking instructions.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 80), // Extra space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: _saveRecipeButton, // 4. Assign the defined button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Moved to the right for standard FAB position
    );
  }
}
