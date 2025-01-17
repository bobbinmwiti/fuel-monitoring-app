// lib/data/repositories/vehicle_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';

class VehicleResult {
  final List<VehicleModel> vehicles;
  final DocumentSnapshot? lastDocument;

  VehicleResult({
    required this.vehicles,
    this.lastDocument,
  });
}

class VehicleRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'vehicles';

  VehicleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get vehicles with pagination
  Future<VehicleResult> getVehicles({
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .orderBy('name')
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      final vehicles = querySnapshot.docs
          .map((doc) => VehicleModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      return VehicleResult(
        vehicles: vehicles,
        lastDocument: querySnapshot.docs.isNotEmpty 
            ? querySnapshot.docs.last 
            : null,
      );
    } catch (e) {
      throw Exception('Failed to get vehicles: $e');
    }
  }

  // Get vehicles needing refuel
  Future<List<VehicleModel>> getVehiclesNeedingRefuel() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('currentFuelLevel', isLessThanOrEqualTo: 20)
          .get();

      return querySnapshot.docs
          .map((doc) => VehicleModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get vehicles needing refuel: $e');
    }
  }

  // Create vehicle
  Future<void> createVehicle(VehicleModel vehicle) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(vehicle.id)
          .set(vehicle.toJson());
    } catch (e) {
      throw Exception('Failed to create vehicle: $e');
    }
  }

  // Update vehicle
  Future<void> updateVehicle(String id, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update({
            ...data,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  // Get vehicle by ID
  Future<VehicleModel?> getVehicleById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      
      return VehicleModel.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to get vehicle: $e');
    }
  }

  // Stream vehicle changes
  Stream<VehicleModel?> streamVehicle(String id) {
    return _firestore
        .collection(_collection)
        .doc(id)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return VehicleModel.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });
        });
  }
}