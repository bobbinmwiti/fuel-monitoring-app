import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../models/vehicle_model.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    required this.success,
  });

  factory ApiResponse.success(T data) => ApiResponse(
        data: data,
        success: true,
      );

  factory ApiResponse.error(String message) => ApiResponse(
        error: message,
        success: false,
      );
}

class ApiClient {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  static const String _usersCollection = 'users';
  static const String _vehiclesCollection = 'vehicles';

  ApiClient({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // User Operations
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return ApiResponse.success(null);
      }

      final doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
      if (!doc.exists) {
        return ApiResponse.success(null);
      }

      final data = doc.data() as Map<String, dynamic>;
      return ApiResponse.success(UserModel.fromJson({
        'id': doc.id,
        'name': data['name'] as String,
        'email': data['email'] as String,
        'phoneNumber': data['phoneNumber'] as String?,
        'profileImage': data['profileImage'] as String?,
        'role': data['role'] as String,
        'createdAt': data['createdAt']?.toDate(),
        'updatedAt': data['updatedAt']?.toDate(),
      }));
    } catch (e) {
      return ApiResponse.error('Failed to get current user: $e');
    }
  }

  Future<ApiResponse<List<UserModel>>> getUsers({
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_usersCollection)
          .orderBy('name')
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          'name': data['name'] as String,
          'email': data['email'] as String,
          'phoneNumber': data['phoneNumber'] as String?,
          'profileImage': data['profileImage'] as String?,
          'role': data['role'] as String,
          'createdAt': data['createdAt']?.toDate(),
          'updatedAt': data['updatedAt']?.toDate(),
        });
      }).toList();

      return ApiResponse.success(users);
    } catch (e) {
      return ApiResponse.error('Failed to get users: $e');
    }
  }

  Future<ApiResponse<UserModel?>> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return ApiResponse.success(null);
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      return ApiResponse.success(UserModel.fromJson({
        'id': doc.id,
        'name': data['name'] as String,
        'email': data['email'] as String,
        'phoneNumber': data['phoneNumber'] as String?,
        'profileImage': data['profileImage'] as String?,
        'role': data['role'] as String,
        'createdAt': data['createdAt']?.toDate(),
        'updatedAt': data['updatedAt']?.toDate(),
      }));
    } catch (e) {
      return ApiResponse.error('Failed to get user by email: $e');
    }
  }

  Future<ApiResponse<void>> createOrUpdateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to create/update user: $e');
    }
  }

  // Vehicle Operations
  Future<ApiResponse<List<VehicleModel>>> getVehicles({
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(_vehiclesCollection)
          .orderBy('name')
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      final vehicles = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return VehicleModel.fromJson({
          'id': doc.id,
          'name': data['name'] as String,
          'licensePlate': data['licensePlate'] as String,
          'make': data['make'] as String,
          'model': data['model'] as String,
          'year': data['year'] as int,
          'fuelType': data['fuelType'] as String,
          'fuelCapacity': (data['fuelCapacity'] as num).toDouble(),
          'currentFuelLevel': (data['currentFuelLevel'] as num).toDouble(),
          'currentOdometer': data['currentOdometer'] as int,
          'status': data['status'] as String,
          'image': data['image'] as String?,
          'lastMaintenance': data['lastMaintenance']?.toDate(),
          'createdAt': data['createdAt'].toDate(),
          'updatedAt': data['updatedAt'].toDate(),
        });
      }).toList();

      return ApiResponse.success(vehicles);
    } catch (e) {
      return ApiResponse.error('Failed to get vehicles: $e');
    }
  }

  // Add similar fixes for other methods...
  // Remember to explicitly map Firestore document data to properly typed Maps
  // Instead of spreading the data directly
}