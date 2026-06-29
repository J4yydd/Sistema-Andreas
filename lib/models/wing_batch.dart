class WingBatchSelection {
  const WingBatchSelection({required this.flavorId});

  final String flavorId;

  bool get isComplete => flavorId.isNotEmpty;
}
