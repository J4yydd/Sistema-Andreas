import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/category.dart';
import 'package:sistema_andreas/screens/botanas_screen.dart';
import 'package:sistema_andreas/screens/pastas_screen.dart';
import 'package:sistema_andreas/screens/pizzas_screen.dart';
import 'package:sistema_andreas/screens/wings_screen.dart';
import 'package:sistema_andreas/utils/categories_data.dart';
import 'package:sistema_andreas/widgets/app_scaffold.dart';
import 'package:sistema_andreas/widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _onCategoryTap(BuildContext context, MenuCategory category) {
    if (category.id == 'pizzas') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const PizzasScreen(),
        ),
      );
      return;
    }

    if (category.id == 'pastas') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const PastasScreen(),
        ),
      );
      return;
    }

    if (category.id == 'alitas') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const WingsScreen(),
        ),
      );
      return;
    }

    if (category.id == 'botanas') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const BotanasScreen(),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Seleccionaste: ${category.name}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1200),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(
        context: context,
        title: 'Nuevo pedido',
        subtitle: 'Selecciona una categoría',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: GridView.builder(
            itemCount: CategoriesData.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final category = CategoriesData.categories[index];
              return CategoryCard(
                category: category,
                onTap: () => _onCategoryTap(context, category),
              );
            },
          ),
        ),
      ),
    );
  }
}
