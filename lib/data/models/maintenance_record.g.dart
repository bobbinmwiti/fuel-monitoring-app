// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceRecord _$MaintenanceRecordFromJson(Map<String, dynamic> json) =>
    MaintenanceRecord(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      cost: (json['cost'] as num).toDouble(),
      serviceProvider: json['serviceProvider'] as String,
      status: json['status'] as String,
      odometerReading: (json['odometerReading'] as num).toDouble(),
      partsReplaced: (json['partsReplaced'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      invoiceUrl: json['invoiceUrl'] as String?,
      nextServiceDue: json['nextServiceDue'] == null
          ? null
          : DateTime.parse(json['nextServiceDue'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MaintenanceRecordToJson(MaintenanceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'type': instance.type,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'cost': instance.cost,
      'serviceProvider': instance.serviceProvider,
      'status': instance.status,
      'odometerReading': instance.odometerReading,
      'partsReplaced': instance.partsReplaced,
      'invoiceUrl': instance.invoiceUrl,
      'nextServiceDue': instance.nextServiceDue?.toIso8601String(),
      'notes': instance.notes,
    };
