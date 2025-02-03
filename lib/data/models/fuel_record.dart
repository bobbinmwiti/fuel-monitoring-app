class FuelRecord {
  final String id;
  final DateTime date;
  final double mileage;
  final String fuelType;
  final double quantity;
  final double price;

  FuelRecord({
    required this.id,
    required this.date,
    required this.mileage,
    required this.fuelType,
    required this.quantity,
    required this.price,
  });
}
