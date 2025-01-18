// lib/data/datasources/local/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get profileImage => text().nullable()();
  TextColumn get role => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get licensePlate => text()();
  TextColumn get make => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  TextColumn get fuelType => text()();
  RealColumn get fuelCapacity => real()();
  RealColumn get currentFuelLevel => real()();
  IntColumn get currentOdometer => integer()();
  TextColumn get status => text()();
  TextColumn get image => text().nullable()();
  DateTimeColumn get lastMaintenance => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class FuelRecords extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get userId => text().references(Users, #id)();
  RealColumn get fuelAmount => real()();
  RealColumn get costPerLiter => real()();
  RealColumn get totalCost => real()();
  IntColumn get odometerReading => integer()();
  DateTimeColumn get fillingDate => dateTime()();
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users, Vehicles, FuelRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // User Operations
  Future<User?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<User?> getUserByEmail(String email) {
    return (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  Future<List<User>> getUsers({int limit = 10, int offset = 0}) {
    return (select(users)..limit(limit, offset: offset)).get();
  }

  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateUser(UsersCompanion user) {
    return update(users).replace(user);
  }

  Future<int> deleteUser(String id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  // Vehicle Operations
  Future<Vehicle?> getVehicleById(String id) {
    return (select(vehicles)..where((v) => v.id.equals(id))).getSingleOrNull();
  }

  Future<List<Vehicle>> getVehicles({int limit = 10, int offset = 0}) {
    return (select(vehicles)
          ..orderBy([(v) => OrderingTerm(expression: v.name)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<List<Vehicle>> getVehiclesNeedingRefuel() {
    return (select(vehicles)..where((v) => v.currentFuelLevel.isSmallerThanValue(20))).get();
  }

  Future<int> insertVehicle(VehiclesCompanion vehicle) {
    return into(vehicles).insert(vehicle, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateVehicle(VehiclesCompanion vehicle) {
    return update(vehicles).replace(vehicle);
  }

  Future<int> deleteVehicle(String id) {
    return (delete(vehicles)..where((v) => v.id.equals(id))).go();
  }

  // Fuel Record Operations
  Future<FuelRecord?> getFuelRecordById(String id) {
    return (select(fuelRecords)..where((f) => f.id.equals(id))).getSingleOrNull();
  }

  Future<List<FuelRecord>> getFuelRecords({int limit = 10, int offset = 0}) {
    return (select(fuelRecords)
          ..orderBy([(f) => OrderingTerm(expression: f.fillingDate, mode: OrderingMode.desc)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<List<FuelRecord>> getVehicleFuelRecords(String vehicleId,
      {int limit = 10, int offset = 0}) {
    return (select(fuelRecords)
          ..where((f) => f.vehicleId.equals(vehicleId))
          ..orderBy([(f) => OrderingTerm(expression: f.fillingDate, mode: OrderingMode.desc)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<int> insertFuelRecord(FuelRecordsCompanion record) {
    return into(fuelRecords).insert(record, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateFuelRecord(FuelRecordsCompanion record) {
    return update(fuelRecords).replace(record);
  }

  Future<int> deleteFuelRecord(String id) {
    return (delete(fuelRecords)..where((f) => f.id.equals(id))).go();
  }

  // Statistics
  Future<Map<String, dynamic>> getVehicleStatistics(String vehicleId) async {
    final records = await (select(fuelRecords)
          ..where((f) => f.vehicleId.equals(vehicleId)))
        .get();

    final totalFuel = records.fold<double>(0, (sum, record) => sum + record.fuelAmount);
    final totalCost = records.fold<double>(0, (sum, record) => sum + record.totalCost);

    return {
      'totalFuel': totalFuel,
      'totalCost': totalCost,
      'recordsCount': records.length,
      'averageCost': records.isNotEmpty ? totalCost / records.length : 0,
    };
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fuel_monitor.db'));
    return NativeDatabase.createInBackground(file);
  });
}