/// Precio por porción de 10 alitas.
const wingsBatchPrice = 130.0;

/// Precio promocional por 20 alitas.
const wingsDoubleBatchPrice = 220.0;

/// Calcula el total según cantidad de alitas (múltiplos de 10).
/// Porciones de 20 aplican [wingsDoubleBatchPrice]; sueltas de 10 usan [wingsBatchPrice].
double calculateWingsTotal(int wingCount) {
  if (wingCount <= 0) return 0;

  final doubleBatches = wingCount ~/ 20;
  final remainder = wingCount % 20;
  var total = doubleBatches * wingsDoubleBatchPrice;
  if (remainder == 10) {
    total += wingsBatchPrice;
  }
  return total;
}

int wingBatchCount(int wingCount) => wingCount ~/ 10;
