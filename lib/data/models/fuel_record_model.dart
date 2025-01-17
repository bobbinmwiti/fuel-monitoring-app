// lib/data/models/fuel_record_model.dart
class FuelRecordModel {
  final String id;
  final String vehicleId;
  final String userId;
  final double fuelAmount;
  final double costPerLiter;
  final double totalCost;
  final int odometerReading;
  final DateTime fillingDate;
  final String? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FuelRecordModel({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.fuelAmount,
    required this.costPerLiter,
    required this.totalCost,
    required this.odometerReading,
    required this.fillingDate,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory FuelRecordModel.fromJson(Map<String, dynamic> json) {
    return FuelRecordModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      userId: json['userId'] as String,
      fuelAmount: (json['fuelAmount'] as num).toDouble(),
      costPerLiter: (json['costPerLiter'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      odometerReading: json['odometerReading'] as int,
      fillingDate: DateTime.parse(json['fillingDate'] as String),
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'userId': userId,
      'fuelAmount': fuelAmount,
      'costPerLiter': costPerLiter,
      'totalCost': totalCost,
      'odometerReading': odometerReading,
      'fillingDate': fillingDate.toIso8601String(),
      'location': location,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with
  FuelRecordModel copyWith({
    String? id,
    String? vehicleId,
    String? userId,
    double? fuelAmount,
    double? costPerLiter,
    double? totalCost,
    int? odometerReading,
    DateTime? fillingDate,
    String? location,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FuelRecordModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      fuelAmount: fuelAmount ?? this.fuelAmount,
      costPerLiter: costPerLiter ?? this.costPerLiter,
      totalCost: totalCost ?? this.totalCost,
      odometerReading: odometerReading ?? this.odometerReading,
      fillingDate: fillingDate ?? this.fillingDate,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties
  double get fuelEfficiency => fuelAmount / odometerReading * 100;
  bool get isRecent => DateTime.now().difference(fillingDate).inDays <= 7;

  @override
  String toString() {
    return 'FuelRecordModel(id: $id, vehicleId: $vehicleId, amount: $fuelAmount)';
  }
}