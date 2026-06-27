import 'package:flutter/material.dart';
import 'package:sistema_andreas/screens/categories_screen.dart';
import 'package:sistema_andreas/services/order_scope.dart';
import 'package:sistema_andreas/services/order_state.dart';
import 'package:sistema_andreas/utils/app_theme.dart';

void main() {
  runApp(const SistemaAndreasApp());
}

class SistemaAndreasApp extends StatefulWidget {
  const SistemaAndreasApp({super.key});

  @override
  State<SistemaAndreasApp> createState() => _SistemaAndreasAppState();
}

class _SistemaAndreasAppState extends State<SistemaAndreasApp> {
  late final OrderState _orderState = OrderState();

  @override
  void dispose() {
    _orderState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrderScope(
      notifier: _orderState,
      child: MaterialApp(
        title: 'Sistema Andreas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const CategoriesScreen(),
      ),
    );
  }
}
