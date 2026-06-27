import 'package:sistema_andreas/models/pizza_size.dart';

class PizzaSizeLabels {
  PizzaSizeLabels._();

  static String singular(PizzaSize size) {
    switch (size.id) {
      case 'personal':
        return 'personal';
      case 'mediana':
        return 'mediana';
      case 'familiar':
        return 'familiar';
      case 'super_familiar':
        return 'super familiar';
      case 'super_18':
        return 'super 18';
      case 'pizza_burro':
        return 'pizza burro';
      default:
        return size.name.toLowerCase();
    }
  }

  static String plural(PizzaSize size) {
    switch (size.id) {
      case 'personal':
        return 'personales';
      case 'mediana':
        return 'medianas';
      case 'familiar':
        return 'familiares';
      case 'super_familiar':
        return 'super familiares';
      case 'super_18':
        return 'super 18';
      case 'pizza_burro':
        return 'pizzas burro';
      default:
        return '${size.name.toLowerCase()}s';
    }
  }
}
