// lib/data/repositories/fuel_record_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fuel_record_model.dart';

class FuelRecordResult {
  final List<FuelRecordModel> records;
  final DocumentSnapshot? lastDocument;

  FuelRecordResult({
    required this.records,
    this.lastDocument,
  });
}

class FuelRecordRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'fuel_records';

  FuelRecordRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get recent fuel records with pagination
  Future<FuelRecordResult> getRecentFuelRecords({
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .orderBy('fillingDate', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      final records = querySnapshot.docs
          .map((doc) => FuelRecordModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      return FuelRecordResult(
        records: records,
        lastDocument: querySnapshot.docs.isNotEmpty 
            ? querySnapshot.docs.last 
            : null,
      );
    } catch (e) {
      throw Exception('Failed to get fuel records: $e');
    }
  }

  // Get fuel records for a specific vehicle
  Future<FuelRecordResult> getVehicleFuelRecords({
    required String vehicleId,
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('vehicleId', isEqualTo: vehicleId)
          .orderBy('fillingDate', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      final records = querySnapshot.docs
          .map((doc) => FuelRecordModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      return FuelRecordResult(
        records: records,
        lastDocument: querySnapshot.docs.isNotEmpty 
            ? querySnapshot.docs.last 
            : null,
      );
    } catch (e) {
      throw Exception('Failed to get vehicle fuel records: $e');
    }
  }

  // Create fuel record
  Future<void> createFuelRecord(FuelRecordModel record) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(record.id)
          .set(record.toJson());
    } catch (e) {
      throw Exception('Failed to create fuel record: $e');
    }
  }

  // Update fuel record
  Future<void> updateFuelRecord(String id, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update({
            ...data,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to update fuel record: $e');
    }
  }

  // Delete fuel record
  Future<void> deleteFuelRecord(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete fuel record: $e');
    }
  }

  // Get fuel statistics for a vehicle
  Future<Map<String, dynamic>> getVehicleStatistics(String vehicleId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('vehicleId', isEqualTo: vehicleId)
          .get();

      final records = querySnapshot.docs
          .map((doc) => FuelRecordModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      final totalFuel = records.fold<double>(
          0, (previousValue, record) => previousValue + record.fuelAmount);
      final totalCost = records.fold<double>(
          0, (previousValue, record) => previousValue + record.totalCost);

      return {
        'totalFuel': totalFuel,
        'totalCost': totalCost,
        'recordsCount': records.length,
        'averageCost': records.isNotEmpty ? totalCost / records.length : 0,
      };
    } catch (e) {
      throw Exception('Failed to get vehicle statistics: $e');
    }
  }
}