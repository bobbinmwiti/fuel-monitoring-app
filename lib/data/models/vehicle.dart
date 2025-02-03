import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  final String id;
  final String plateNumber;
  final String model;
  final String type;
  final double fuelCapacity;
  final double currentFuelLevel;
  final double averageFuelConsumption;
  final String driverId;
  final String status; // active, maintenance, inactive
  final DateTime? lastMaintenance;  // Changed from lastMaintenanceDate
  final double totalMileage;
  final double lastRefuelAmount;
  final DateTime lastRefuelDate;
  final Map<String, dynamic>? telemetryData;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.model,
    required this.type,
    required this.fuelCapacity,
    required this.currentFuelLevel,
    required this.averageFuelConsumption,
    required this.driverId,
    required this.status,
    this.lastMaintenance,  // Made optional
    required this.totalMileage,
    required this.lastRefuelAmount,
    required this.lastRefuelDate,
    this.telemetryData,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  double get fuelEfficiency => totalMileage / lastRefuelAmount;
  bool get needsMaintenance => lastMaintenance == null || DateTime.now().difference(lastMaintenance!).inDays > 30;
  bool get needsRefuel => currentFuelLevel / fuelCapacity < 0.2; // 20% threshold
}
