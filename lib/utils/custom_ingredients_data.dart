import 'package:sistema_andreas/models/pizza_ingredient.dart';

class CustomIngredientsData {
  CustomIngredientsData._();

  static const String personalizadoId = 'personalizado';

  static const List<PizzaIngredient> ingredients = [
    PizzaIngredient(id: 'jamon', name: 'Jamón'),
    PizzaIngredient(id: 'chorizo', name: 'Chorizo'),
    PizzaIngredient(id: 'champinon', name: 'Champiñón'),
    PizzaIngredient(id: 'pina', name: 'Piña'),
    PizzaIngredient(id: 'peperonni', name: 'Peperonni'),
    PizzaIngredient(id: 'salami', name: 'Salami'),
    PizzaIngredient(id: 'tocino', name: 'Tocino'),
    PizzaIngredient(id: 'arrachera', name: 'Arrachera'),
    PizzaIngredient(id: 'cebolla', name: 'Cebolla'),
    PizzaIngredient(id: 'jitomate', name: 'Jitomate'),
    PizzaIngredient(id: 'jalapeno', name: 'Jalapeño'),
    PizzaIngredient(id: 'pimiento', name: 'Pimiento'),
    PizzaIngredient(id: 'aceitunas_negras', name: 'Aceitunas negras'),
    PizzaIngredient(id: 'salchicha_italiana', name: 'Salchicha italiana'),
    PizzaIngredient(id: 'atun', name: 'Atún'),
    PizzaIngredient(id: 'ranchera', name: 'Ranchera'),
  ];

  static PizzaIngredient? findById(String id) {
    for (final ingredient in ingredients) {
      if (ingredient.id == id) return ingredient;
    }
    return null;
  }

  static List<String> ingredientNames(List<String> ids) {
    return ids
        .map((id) => findById(id)?.name)
        .whereType<String>()
        .toList();
  }
}
