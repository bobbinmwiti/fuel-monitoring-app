// lib/features/vehicle/bloc/vehicle_event.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/vehicle_model.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicles extends VehicleEvent {
  final int limit;

  const LoadVehicles({
    this.limit = 10,
  });

  @override
  List<Object> get props => [limit];
}

class LoadMoreVehicles extends VehicleEvent {
  const LoadMoreVehicles();
}

class LoadVehicleDetails extends VehicleEvent {
  final String vehicleId;

  const LoadVehicleDetails(this.vehicleId);

  @override
  List<Object> get props => [vehicleId];
}

class AddVehicle extends VehicleEvent {
  final VehicleModel vehicle;

  const AddVehicle(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class UpdateVehicle extends VehicleEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateVehicle(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class DeleteVehicle extends VehicleEvent {
  final String id;

  const DeleteVehicle(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshVehicles extends VehicleEvent {
  const RefreshVehicles();
}

class WatchVehicle extends VehicleEvent {
  final String id;

  const WatchVehicle(this.id);

  @override
  List<Object> get props => [id];
}

class StopWatchingVehicle extends VehicleEvent {
  const StopWatchingVehicle();
}