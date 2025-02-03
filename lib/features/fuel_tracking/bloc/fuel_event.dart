// lib/features/fuel_tracking/bloc/fuel_event.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/fuel_record_model.dart';

abstract class FuelEvent extends Equatable {
  const FuelEvent();

  @override
  List<Object?> get props => [];
}

class LoadFuelRecords extends FuelEvent {
  final String? vehicleId;
  final int limit;
  
  const LoadFuelRecords({
    this.vehicleId,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [vehicleId, limit];
}

class LoadMoreFuelRecords extends FuelEvent {
  final String? vehicleId;
  
  const LoadMoreFuelRecords({
    this.vehicleId,
  });

  @override
  List<Object?> get props => [vehicleId];
}

class AddFuelRecord extends FuelEvent {
  final FuelRecordModel record;

  const AddFuelRecord(this.record);

  @override
  List<Object> get props => [record];
}

class UpdateFuelRecord extends FuelEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateFuelRecord(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class DeleteFuelRecord extends FuelEvent {
  final String id;

  const DeleteFuelRecord(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshFuelRecords extends FuelEvent {
  final String? vehicleId;

  const RefreshFuelRecords({this.vehicleId});

  @override
  List<Object?> get props => [vehicleId];
}