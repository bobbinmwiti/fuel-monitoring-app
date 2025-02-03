import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/iot_service.dart';
import '../../../data/models/sensor_reading_model.dart';

class RealTimeFuelMonitor extends StatefulWidget {
  final String vehicleId;

  const RealTimeFuelMonitor({
    super.key,
    required this.vehicleId,
  });

  @override
  State<RealTimeFuelMonitor> createState() => _RealTimeFuelMonitorState();
}

class _RealTimeFuelMonitorState extends State<RealTimeFuelMonitor> {
  final IoTService _iotService = GetIt.I<IoTService>();
  SensorReadingModel? _lastReading;

  @override
  void initState() {
    super.initState();
    _iotService.subscribeToVehicle(widget.vehicleId);
    _iotService.sensorDataStream.listen((reading) {
      if (reading.vehicleId == widget.vehicleId) {
        setState(() {
          _lastReading = reading;
        });
      }
    });
  }

  @override
  void dispose() {
    _iotService.unsubscribeFromVehicle(widget.vehicleId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real-Time Fuel Monitor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_lastReading != null) ...[
              _buildInfoRow(
                'Fuel Level',
                '${_lastReading!.fuelLevel.toStringAsFixed(1)} L',
              ),
              _buildInfoRow(
                'Temperature',
                '${_lastReading!.temperature.toStringAsFixed(1)}°C',
              ),
              _buildInfoRow(
                'Last Updated',
                _formatDateTime(_lastReading!.timestamp),
              ),
            ] else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
