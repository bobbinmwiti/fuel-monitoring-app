import 'package:cloud_firestore/cloud_firestore.dart';

class SensorReadingModel {
  final String id;
  final String vehicleId;
  final double fuelLevel;
  final double temperature;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  SensorReadingModel({
    required this.id,
    required this.vehicleId,
    required this.fuelLevel,
    required this.temperature,
    required this.timestamp,
    this.metadata,
  });

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      fuelLevel: (json['fuelLevel'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'fuelLevel': fuelLevel,
      'temperature': temperature,
      'timestamp': Timestamp.fromDate(timestamp),
      'metadata': metadata,
    };
  }

  SensorReadingModel copyWith({
    String? id,
    String? vehicleId,
    double? fuelLevel,
    double? temperature,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return SensorReadingModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      temperature: temperature ?? this.temperature,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}
