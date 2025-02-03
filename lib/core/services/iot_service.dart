import 'dart:async';
import 'package:iot_fuel/data/models/sensor_reading_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'package:logging/logging.dart';

class IoTService {
  static const String mqttBrokerUrl = 'your_broker_here';
  static const int mqttPortNumber = 1883;
  static const String mqttUsernameValue = 'your_username';
  static const String mqttPasswordValue = 'your_password';

  final Logger _logger = Logger('IoTService');

  late MqttServerClient _client;
  final StreamController<SensorReadingModel> _sensorDataController =
      StreamController<SensorReadingModel>.broadcast();

  Stream<SensorReadingModel> get sensorDataStream =>
      _sensorDataController.stream;

  Future<void> initialize() async {
    _client = MqttServerClient(mqttBrokerUrl, 'flutter_fuel_app');
    _client.port = mqttPortNumber;
    _client.logging(on: true);
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .authenticateAs(mqttUsernameValue, mqttPasswordValue)
        .withClientIdentifier('flutter_fuel_app')
        .withWillTopic('willTopic')
        .withWillMessage('disconnected')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } on Exception catch (e) {
      _logger.severe('Exception: $e');
      _client.disconnect();
    }
  }

  void _onConnected() {
    _logger.info('Connected to MQTT Broker');
    _client.subscribe('fuel/+/data', MqttQos.atLeastOnce);
  }

  void _onDisconnected() {
    _logger.info('Disconnected from MQTT Broker');
  }

  void _onSubscribed(String topic) {
    _logger.info('Subscribed to topic: $topic');
  }

  void subscribeToVehicle(String vehicleId) {
    final topic = 'fuel/$vehicleId/data';
    _client.subscribe(topic, MqttQos.atLeastOnce);

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      try {
        final data = json.decode(payload);
        final reading = SensorReadingModel.fromJson(data);
        _sensorDataController.add(reading);
      } catch (e) {
        _logger.severe('Error parsing sensor data: $e');
      }
    });
  }

  void unsubscribeFromVehicle(String vehicleId) {
    final topic = 'fuel/$vehicleId/data';
    _client.unsubscribe(topic);
  }

  void dispose() {
    _client.disconnect();
    _sensorDataController.close();
  }

  Future<void> publishCommand(
      String vehicleId, String command, Map<String, dynamic> data) async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      _logger.warning('Client is not connected');
      return;
    }

    final topic = 'fuel/$vehicleId/command';
    final payload = json.encode({
      'command': command,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _client.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: false,
    );
  }
}
