import 'package:json_annotation/json_annotation.dart';

part 'maintenance_record.g.dart';

@JsonSerializable()
class MaintenanceRecord {
  final String id;
  final String vehicleId;
  final String type; // routine, repair, emergency
  final DateTime date;
  final String description;
  final double cost;
  final String serviceProvider;
  final String status; // scheduled, in_progress, completed
  final double odometerReading;
  final List<String> partsReplaced;
  final String? invoiceUrl;
  final DateTime? nextServiceDue;
  final String? notes;

  MaintenanceRecord({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.description,
    required this.cost,
    required this.serviceProvider,
    required this.status,
    required this.odometerReading,
    required this.partsReplaced,
    this.invoiceUrl,
    this.nextServiceDue,
    this.notes,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) => _$MaintenanceRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceRecordToJson(this);

  bool get isCompleted => status == 'completed';
  bool get isOverdue => nextServiceDue != null && DateTime.now().isAfter(nextServiceDue!);
  bool get hasInvoice => invoiceUrl != null && invoiceUrl!.isNotEmpty;
}
