class SensorReadingModel {
  final String vehicleId;
  final double fuelLevel;
  final DateTime timestamp;

  SensorReadingModel({
    required this.vehicleId,
    required this.fuelLevel,
    required this.timestamp,
  });

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      vehicleId: json['vehicleId'],
      fuelLevel: json['fuelLevel'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'fuelLevel': fuelLevel,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
