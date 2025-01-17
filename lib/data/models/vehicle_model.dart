// lib/data/models/vehicle_model.dart
class VehicleModel {
  final String id;
  final String name;
  final String licensePlate;
  final String make;
  final String model;
  final int year;
  final String fuelType;
  final double fuelCapacity;
  final double currentFuelLevel;
  final int currentOdometer;
  final String status;
  final String? image;
  final DateTime? lastMaintenance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.fuelCapacity,
    required this.currentFuelLevel,
    required this.currentOdometer,
    required this.status,
    this.image,
    this.lastMaintenance,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      licensePlate: json['licensePlate'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      fuelType: json['fuelType'] as String,
      fuelCapacity: (json['fuelCapacity'] as num).toDouble(),
      currentFuelLevel: (json['currentFuelLevel'] as num).toDouble(),
      currentOdometer: json['currentOdometer'] as int,
      status: json['status'] as String,
      image: json['image'] as String?,
      lastMaintenance: json['lastMaintenance'] != null 
          ? DateTime.parse(json['lastMaintenance'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'licensePlate': licensePlate,
      'make': make,
      'model': model,
      'year': year,
      'fuelType': fuelType,
      'fuelCapacity': fuelCapacity,
      'currentFuelLevel': currentFuelLevel,
      'currentOdometer': currentOdometer,
      'status': status,
      'image': image,
      'lastMaintenance': lastMaintenance?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with
  VehicleModel copyWith({
    String? id,
    String? name,
    String? licensePlate,
    String? make,
    String? model,
    int? year,
    String? fuelType,
    double? fuelCapacity,
    double? currentFuelLevel,
    int? currentOdometer,
    String? status,
    String? image,
    DateTime? lastMaintenance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      licensePlate: licensePlate ?? this.licensePlate,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      fuelType: fuelType ?? this.fuelType,
      fuelCapacity: fuelCapacity ?? this.fuelCapacity,
      currentFuelLevel: currentFuelLevel ?? this.currentFuelLevel,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      status: status ?? this.status,
      image: image ?? this.image,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties
  double get fuelPercentage => (currentFuelLevel / fuelCapacity) * 100;
  bool get needsRefueling => fuelPercentage < 20;
  String get fullName => '$year $make $model';

  @override
  String toString() {
    return 'VehicleModel(id: $id, name: $name, licensePlate: $licensePlate)';
  }
}