import 'package:recipe/data/drift/drift_db.dart';
import 'package:recipe/data/models/models.dart';
import 'package:recipe/data/repository.dart';

class DriftRepository extends Repository {
  late RecipeDatabase recipeDatabase;
  late RecipeDao _recipeDao;
  late IngredientDao _ingredientDao;
  Stream<List<Ingredient>>? ingredientStream;
  Stream<List<Recipe>>? recipeStream;

  // TODO: Add findAllRecipes()
  // TODO: Add watchAllRecipes()
  // TODO: Add watchAllIngredients()
  // TODO: Add findRecipeById()
  // TODO: Add findAllIngredients()
  // TODO: Add findRecipeIngredients()
  // TODO: Add insertRecipe()
  // TODO: Add insertIngredients()
  // TODO: Add Delete methods

  @override
  Future init() async {
    recipeDatabase = RecipeDatabase();
    _recipeDao = recipeDatabase.recipeDao;
    _ingredientDao = recipeDatabase.ingredientDao;
  }

  @override
  void close() {
    recipeDatabase.close();
  }

  @override
  Future<List<Recipe>> findAllRecipes() {
    return _recipeDao.findAllRecipes().then<List<Recipe>>(
      (List<DriftRecipeData> driftRecipes) {
        final recipes = <Recipe>[];
        driftRecipes.forEach(
          (driftRecipe) async {
            final recipe = driftRecipeToRecipe(driftRecipe);
            if (recipe.id != null) {
              recipe.ingredients = await findRecipeIngredients(recipe.id!);
            }
            recipes.add(recipe);
          },
        );
        return recipes;
      },
    );
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    recipeStream ??= _recipeDao.watchAllRecipes();
    return recipeStream!;
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    if (ingredientStream == null) {
      final stream = _ingredientDao.watchAllIngredients();
      ingredientStream = stream.map(
        (driftIngredients) {
          final ingredients = <Ingredient>[];
          for (var driftIngredient in driftIngredients) {
            ingredients.add(driftIngredientToIngredient(driftIngredient));
          }
          return ingredients;
        },
      );
    }
    return ingredientStream!;
  }

  @override
  Future<Recipe> findRecipeById(int id) {
    return _recipeDao
        .findRecipeById(id)
        .then((listOfRecipes) => driftRecipeToRecipe(listOfRecipes.first));
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return _ingredientDao.findAllIngredients().then<List<Ingredient>>(
      (List<DriftIngredientData> driftIngredients) {
        final ingredients = <Ingredient>[];
        for (var ingredient in driftIngredients) {
          ingredients.add(driftIngredientToIngredient(ingredient));
        }
        return ingredients;
      },
    );
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    return _ingredientDao.findRecipeIngredients(recipeId).then(
      (listOfIngredients) {
        final ingredients = <Ingredient>[];
        for (var ingredient in listOfIngredients) {
          ingredients.add(driftIngredientToIngredient(ingredient));
        }
        return ingredients;
      },
    );
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    return Future(
      () async {
        final id = await _recipeDao
            .insertRecipe(recipeToInsertableDriftRecipe(recipe));
        if (recipe.ingredients != null) {
          for (var ingredient in recipe.ingredients!) {
            ingredient.recipeId = id;
          }
          insertIngredients(recipe.ingredients!);
        }
        return id;
      },
    );
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    return Future(() {
      if (ingredients.isEmpty) {
        return <int>[];
      }
      final resultIds = <int>[];
      for (var ingredient in ingredients) {
        final driftIngredient =
            ingredientToInsertableDriftIngredient(ingredient);
        _ingredientDao
            .insertIngredient(driftIngredient)
            .then((int id) => resultIds.add(id));
      }
      return resultIds;
    });
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) {
    if (recipe.id != null) {
      _recipeDao.deleteRecipe(recipe.id!);
    }
    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    if (ingredient.id != null) {
      return _ingredientDao.deleteIngredient(ingredient.id!);
    } else {
      return Future.value();
    }
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    for (var ingredient in ingredients) {
      if (ingredient.id != null) {
        _ingredientDao.deleteIngredient(ingredient.id!);
      }
    }
    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) async {
    final ingredients = await findRecipeIngredients(recipeId);
    return deleteIngredients(ingredients);
  }
}
