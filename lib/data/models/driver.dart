import 'package:json_annotation/json_annotation.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver {
  final String id;
  final String? name;
  final String licenseNumber;
  final String phoneNumber;
  final String email;
  final String? status; // active, on_leave, inactive
  final DateTime? licenseExpiryDate;
  final List<String>? assignedVehicleIds;
  final Map<String, dynamic>? performanceMetrics;
  final DateTime? lastActiveTime;

  Driver({
    required this.id,
    this.name,
    required this.licenseNumber,
    required this.phoneNumber,
    required this.email,
    this.status,
    this.licenseExpiryDate,
    this.assignedVehicleIds,
    this.performanceMetrics,
    this.lastActiveTime,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
  Map<String, dynamic> toJson() => _$DriverToJson(this);

  bool get isLicenseValid => licenseExpiryDate != null && DateTime.now().isBefore(licenseExpiryDate!);
  bool get isActive => status == 'active';
  bool get hasMultipleVehicles => assignedVehicleIds != null && assignedVehicleIds!.length > 1;
}
