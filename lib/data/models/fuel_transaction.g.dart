// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuelTransaction _$FuelTransactionFromJson(Map<String, dynamic> json) =>
    FuelTransaction(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      driverId: json['driverId'] as String,
      amount: (json['amount'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      stationName: json['stationName'] as String,
      odometerReading: (json['odometerReading'] as num).toDouble(),
      fuelType: json['fuelType'] as String,
      pricePerLiter: (json['pricePerLiter'] as num).toDouble(),
      location: json['location'] as Map<String, dynamic>?,
      receiptUrl: json['receiptUrl'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$FuelTransactionToJson(FuelTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'driverId': instance.driverId,
      'amount': instance.amount,
      'cost': instance.cost,
      'timestamp': instance.timestamp.toIso8601String(),
      'stationName': instance.stationName,
      'odometerReading': instance.odometerReading,
      'fuelType': instance.fuelType,
      'pricePerLiter': instance.pricePerLiter,
      'location': instance.location,
      'receiptUrl': instance.receiptUrl,
      'status': instance.status,
      'notes': instance.notes,
    };
