// lib/data/datasources/local/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class FuelRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable().references(Users, #id)();
  RealColumn get amount => real()();
  TextColumn get fuelType => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get location => text().nullable()();
  RealColumn get cost => real()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users, FuelRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // User operations
  Future<List<User>> getAllUsers() => select(users).get();
  
  Future<User> getUser(String id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingle();
      
  Future<int> insertUser(UsersCompanion user) =>
      into(users).insert(user);
      
  Future<bool> updateUser(UsersCompanion user) =>
      update(users).replace(user);
      
  Future<int> deleteUser(String id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();

  // Fuel record operations
  Future<List<FuelRecord>> getAllFuelRecords() => select(fuelRecords).get();
  
  Future<List<FuelRecord>> getUserFuelRecords(String userId) =>
      (select(fuelRecords)..where((r) => r.userId.equals(userId))).get();
      
  Future<int> insertFuelRecord(FuelRecordsCompanion record) =>
      into(fuelRecords).insert(record);
      
  Future<bool> updateFuelRecord(FuelRecordsCompanion record) =>
      update(fuelRecords).replace(record);
      
  Future<int> deleteFuelRecord(String id) =>
      (delete(fuelRecords)..where((r) => r.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fuel_app.db'));
    return NativeDatabase(file);
  });
}