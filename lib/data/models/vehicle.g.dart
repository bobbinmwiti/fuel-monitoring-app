// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: json['id'] as String,
      plateNumber: json['plateNumber'] as String,
      model: json['model'] as String,
      type: json['type'] as String,
      fuelCapacity: (json['fuelCapacity'] as num).toDouble(),
      currentFuelLevel: (json['currentFuelLevel'] as num).toDouble(),
      averageFuelConsumption:
          (json['averageFuelConsumption'] as num).toDouble(),
      driverId: json['driverId'] as String,
      status: json['status'] as String,
      lastMaintenance: json['lastMaintenance'] == null
          ? null
          : DateTime.parse(json['lastMaintenance'] as String),
      totalMileage: (json['totalMileage'] as num).toDouble(),
      lastRefuelAmount: (json['lastRefuelAmount'] as num).toDouble(),
      lastRefuelDate: DateTime.parse(json['lastRefuelDate'] as String),
      telemetryData: json['telemetryData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'plateNumber': instance.plateNumber,
      'model': instance.model,
      'type': instance.type,
      'fuelCapacity': instance.fuelCapacity,
      'currentFuelLevel': instance.currentFuelLevel,
      'averageFuelConsumption': instance.averageFuelConsumption,
      'driverId': instance.driverId,
      'status': instance.status,
      'lastMaintenance': instance.lastMaintenance?.toIso8601String(),
      'totalMileage': instance.totalMileage,
      'lastRefuelAmount': instance.lastRefuelAmount,
      'lastRefuelDate': instance.lastRefuelDate.toIso8601String(),
      'telemetryData': instance.telemetryData,
    };
