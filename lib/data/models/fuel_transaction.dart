import 'package:json_annotation/json_annotation.dart';

part 'fuel_transaction.g.dart';

@JsonSerializable()
class FuelTransaction {
  final String id;
  final String vehicleId;
  final String driverId;
  final double amount;
  final double cost;
  final DateTime timestamp;
  final String stationName;
  final double odometerReading;
  final String fuelType;
  final double pricePerLiter;
  final Map<String, dynamic>? location;
  final String? receiptUrl;
  final String status; // pending, approved, rejected
  final String? notes;

  FuelTransaction({
    required this.id,
    required this.vehicleId,
    required this.driverId,
    required this.amount,
    required this.cost,
    required this.timestamp,
    required this.stationName,
    required this.odometerReading,
    required this.fuelType,
    required this.pricePerLiter,
    this.location,
    this.receiptUrl,
    required this.status,
    this.notes,
  });

  factory FuelTransaction.fromJson(Map<String, dynamic> json) => _$FuelTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$FuelTransactionToJson(this);

  double get costPerKm => cost / odometerReading;
  bool get isPending => status == 'pending';
  bool get hasReceipt => receiptUrl != null && receiptUrl!.isNotEmpty;
}
