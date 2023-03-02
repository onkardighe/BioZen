class Supply {
  final String id;
  final String title;
  final String quantity;
  final String temperature;
  final DateTime createdAt;

  final bool initiated;
  late bool isBuyerAdded;
  late bool isTransporterAdded;
  late bool isInsuranceAdded;
  late bool isCompleted;

  Supply({
    required this.id,
    required this.title,
    required this.quantity,
    required this.temperature,
    required this.createdAt,
    required this.initiated,
    required this.isBuyerAdded,
    required this.isTransporterAdded,
    required this.isInsuranceAdded,
    required this.isCompleted,
  });
}
