import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/category.dart';
import 'package:sistema_andreas/utils/app_colors.dart';

class CategoriesData {
  CategoriesData._();

  static const List<MenuCategory> categories = [
    MenuCategory(
      id: 'pizzas',
      name: 'Pizzas',
      icon: Icons.local_pizza_rounded,
      color: AppColors.categoryPizza,
    ),
    MenuCategory(
      id: 'fundidos_sopas',
      name: 'Fundidos y Sopas',
      icon: Icons.ramen_dining_rounded,
      color: AppColors.categoryFundidos,
    ),
    MenuCategory(
      id: 'pastas',
      name: 'Pastas',
      icon: Icons.dinner_dining_rounded,
      color: AppColors.categoryPastas,
    ),
    MenuCategory(
      id: 'hamburguesas',
      name: 'Hamburguesas',
      icon: Icons.lunch_dining_rounded,
      color: AppColors.categoryHamburguesas,
    ),
    MenuCategory(
      id: 'alitas',
      name: 'Alitas',
      icon: Icons.set_meal_rounded,
      color: AppColors.categoryAlitas,
    ),
    MenuCategory(
      id: 'botanas',
      name: 'Botanas',
      icon: Icons.tapas_rounded,
      color: AppColors.categoryBotanas,
    ),
    MenuCategory(
      id: 'bebidas',
      name: 'Bebidas',
      icon: Icons.local_drink_rounded,
      color: AppColors.categoryBebidas,
    ),
    MenuCategory(
      id: 'otros',
      name: 'Otros',
      icon: Icons.more_horiz_rounded,
      color: AppColors.categoryOtros,
    ),
  ];
}
