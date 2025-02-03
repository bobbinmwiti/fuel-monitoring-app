import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/driver.dart';
import '../../data/models/fuel_transaction.dart';
import '../../data/models/maintenance_record.dart';
import 'package:intl/intl.dart';

class FleetManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Vehicle Management
  Future<List<Vehicle>> getVehicles() async {
    final snapshot = await _firestore.collection('vehicles').get();
    return snapshot.docs.map((doc) => Vehicle.fromJson(doc.data())).toList();
  }

  Future<Vehicle> getVehicleById(String id) async {
    final doc = await _firestore.collection('vehicles').doc(id).get();
    return Vehicle.fromJson(doc.data()!);
  }

  Stream<List<Vehicle>> getVehiclesStream() {
    return _firestore.collection('vehicles').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Vehicle.fromJson(doc.data()))
              .toList(),
        );
  }

  // Driver Management
  Future<List<Driver>> getDrivers() async {
    final snapshot = await _firestore.collection('drivers').get();
    return snapshot.docs.map((doc) => Driver.fromJson(doc.data())).toList();
  }

  Future<Driver> getDriverById(String id) async {
    final doc = await _firestore.collection('drivers').doc(id).get();
    return Driver.fromJson(doc.data()!);
  }

  // Fuel Transaction Management
  Future<void> addFuelTransaction(FuelTransaction transaction) async {
    await _firestore.collection('fuel_transactions').add(transaction.toJson());
    
    // Update vehicle's fuel level and last refuel info
    await _firestore.collection('vehicles').doc(transaction.vehicleId).update({
      'currentFuelLevel': FieldValue.increment(transaction.amount),
      'lastRefuelAmount': transaction.amount,
      'lastRefuelDate': transaction.timestamp,
    });
  }

  Future<List<FuelTransaction>> getVehicleFuelTransactions(String vehicleId) async {
    final snapshot = await _firestore
        .collection('fuel_transactions')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => FuelTransaction.fromJson(doc.data())).toList();
  }

  // Maintenance Management
  Future<void> scheduleMaintenance(MaintenanceRecord record) async {
    await _firestore.collection('maintenance_records').add(record.toJson());
    
    // Update vehicle's last maintenance date
    await _firestore.collection('vehicles').doc(record.vehicleId).update({
      'lastMaintenanceDate': record.date,
      'status': 'maintenance',
    });
  }

  Future<List<MaintenanceRecord>> getVehicleMaintenanceHistory(String vehicleId) async {
    final snapshot = await _firestore
        .collection('maintenance_records')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => MaintenanceRecord.fromJson(doc.data())).toList();
  }

  // Analytics
  Future<Map<String, dynamic>> getFleetAnalytics() async {
    final vehicles = await getVehicles();
    final fuelTransactions = await _firestore.collection('fuel_transactions').get();
    final maintenanceRecords = await _firestore.collection('maintenance_records').get();

    double totalFuelCost = 0;
    double totalMaintenanceCost = 0;
    int activeVehicles = 0;
    int vehiclesNeedingMaintenance = 0;
    int vehiclesNeedingRefuel = 0;

    for (var vehicle in vehicles) {
      if (vehicle.status == 'active') activeVehicles++;
      if (vehicle.needsMaintenance) vehiclesNeedingMaintenance++;
      if (vehicle.needsRefuel) vehiclesNeedingRefuel++;
    }

    for (var doc in fuelTransactions.docs) {
      totalFuelCost += (doc.data()['cost'] as num).toDouble();
    }

    for (var doc in maintenanceRecords.docs) {
      totalMaintenanceCost += (doc.data()['cost'] as num).toDouble();
    }

    return {
      'totalVehicles': vehicles.length,
      'activeVehicles': activeVehicles,
      'vehiclesNeedingMaintenance': vehiclesNeedingMaintenance,
      'vehiclesNeedingRefuel': vehiclesNeedingRefuel,
      'totalFuelCost': totalFuelCost,
      'totalMaintenanceCost': totalMaintenanceCost,
      'averageFuelCostPerVehicle': totalFuelCost / vehicles.length,
      'averageMaintenanceCostPerVehicle': totalMaintenanceCost / vehicles.length,
    };
  }

  // Route Optimization
  Future<void> updateVehicleRoute(String vehicleId, List<Map<String, dynamic>> waypoints) async {
    await _firestore.collection('vehicles').doc(vehicleId).update({
      'currentRoute': waypoints,
      'lastRouteUpdate': DateTime.now(),
    });
  }

  // Fuel Efficiency Monitoring
  Future<Map<String, dynamic>> getVehicleFuelEfficiencyReport(String vehicleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    startDate ??= DateTime.now().subtract(const Duration(days: 30));
    endDate ??= DateTime.now();

    final transactions = await _firestore
        .collection('fuel_transactions')
        .where('vehicleId', isEqualTo: vehicleId)
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .where('timestamp', isLessThanOrEqualTo: endDate)
        .get();

    double totalFuel = 0;
    double totalCost = 0;
    double totalDistance = 0;
    List<Map<String, dynamic>> fuelEfficiencyData = [];

    for (var doc in transactions.docs) {
      final data = doc.data();
      totalFuel += (data['amount'] as num).toDouble();
      totalCost += (data['cost'] as num).toDouble();
      totalDistance += (data['odometerReading'] as num).toDouble();

      fuelEfficiencyData.add({
        'date': DateFormat('yyyy-MM-dd').format(data['timestamp'].toDate()),
        'efficiency': (data['odometerReading'] as num).toDouble() / (data['amount'] as num).toDouble(),
      });
    }

    return {
      'totalFuelConsumption': totalFuel,
      'totalCost': totalCost,
      'totalDistance': totalDistance,
      'averageEfficiency': totalDistance / totalFuel,
      'costPerKilometer': totalCost / totalDistance,
      'efficiencyTrend': fuelEfficiencyData,
    };
  }
}
