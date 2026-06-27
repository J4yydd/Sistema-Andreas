import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/utils/pizza_pricing.dart';

void main() {
  group('calculatePizzaTotal', () {
    const unit = 82.0;
    const promo = 146.0;

    test('0 unidades = 0', () {
      expect(calculatePizzaTotal(0, unit, promoPairPrice: promo), 0);
    });

    test('1 unidad = precio normal', () {
      expect(calculatePizzaTotal(1, unit, promoPairPrice: promo), 82);
    });

    test('2 unidades = precio promoción', () {
      expect(calculatePizzaTotal(2, unit, promoPairPrice: promo), 146);
    });

    test('3 unidades = promo + 1 normal', () {
      expect(calculatePizzaTotal(3, unit, promoPairPrice: promo), 228);
    });

    test('4 unidades = 2 promos', () {
      expect(calculatePizzaTotal(4, unit, promoPairPrice: promo), 292);
    });

    test('sin promoción multiplica precio unitario', () {
      expect(calculatePizzaTotal(3, 90), 270);
    });

    test('Mediana: 2 unidades = 279', () {
      expect(
        calculatePizzaTotal(2, 169, promoPairPrice: 279),
        279,
      );
    });

    test('Familiar: 2 unidades = 319', () {
      expect(
        calculatePizzaTotal(2, 108, promoPairPrice: 319),
        319,
      );
    });
  });
}
