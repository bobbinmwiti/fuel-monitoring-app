// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      id: json['id'] as String,
      name: json['name'] as String?,
      licenseNumber: json['licenseNumber'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      status: json['status'] as String?,
      licenseExpiryDate: json['licenseExpiryDate'] == null
          ? null
          : DateTime.parse(json['licenseExpiryDate'] as String),
      assignedVehicleIds: (json['assignedVehicleIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      performanceMetrics: json['performanceMetrics'] as Map<String, dynamic>?,
      lastActiveTime: json['lastActiveTime'] == null
          ? null
          : DateTime.parse(json['lastActiveTime'] as String),
    );

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'licenseNumber': instance.licenseNumber,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'status': instance.status,
      'licenseExpiryDate': instance.licenseExpiryDate?.toIso8601String(),
      'assignedVehicleIds': instance.assignedVehicleIds,
      'performanceMetrics': instance.performanceMetrics,
      'lastActiveTime': instance.lastActiveTime?.toIso8601String(),
    };
