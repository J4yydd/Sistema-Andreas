import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/main.dart';

void main() {
  testWidgets('Muestra las categorías del menú', (WidgetTester tester) async {
    await tester.pumpWidget(const SistemaAndreasApp());
    await tester.pumpAndSettle();

    expect(find.text('Nuevo pedido'), findsOneWidget);

    for (final name in [
      'Pizzas',
      'Fundidos y Sopas',
      'Pastas',
      'Hamburguesas',
      'Alitas',
      'Botanas',
      'Bebidas',
      'Otros',
    ]) {
      await tester.scrollUntilVisible(
        find.text(name),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(name), findsOneWidget);
    }
  });
}
