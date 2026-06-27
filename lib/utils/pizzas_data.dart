import 'package:sistema_andreas/models/pizza_size.dart';

class PizzasData {
  PizzasData._();

  static const List<PizzaSize> sizes = [
    PizzaSize(
      id: 'personal',
      name: 'Personal',
      unitPrice: 82,
      promoPairPrice: 146,
      extraIngredientPrice: 15,
    ),
    PizzaSize(
      id: 'mediana',
      name: 'Mediana',
      unitPrice: 169,
      promoPairPrice: 279,
      extraIngredientPrice: 19,
      cheeseCrustPrice: 50,
    ),
    PizzaSize(
      id: 'familiar',
      name: 'Familiar',
      unitPrice: 108,
      promoPairPrice: 319,
      extraIngredientPrice: 21,
      cheeseCrustPrice: 60,
    ),
    PizzaSize(
      id: 'super_familiar',
      name: 'Super Familiar',
      unitPrice: 239,
      promoPairPrice: 396,
      extraIngredientPrice: 29,
      cheeseCrustPrice: 80,
    ),
    PizzaSize(
      id: 'super_18',
      name: 'Super 18',
      unitPrice: 272,
      promoPairPrice: 454,
      extraIngredientPrice: 35,
      cheeseCrustPrice: 100,
    ),
    PizzaSize(
      id: 'pizza_burro',
      name: 'Pizza Burro',
      unitPrice: 90,
    ),
  ];
}
