// lib/features/vehicle/bloc/vehicle_state.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/vehicle_model.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

class VehicleLoaded extends VehicleState {
  final List<VehicleModel> vehicles;
  final bool hasMore;
  final bool isLoadingMore;
  final DateTime lastUpdated;

  const VehicleLoaded({
    required this.vehicles,
    this.hasMore = true,
    this.isLoadingMore = false,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [vehicles, hasMore, isLoadingMore, lastUpdated];

  VehicleLoaded copyWith({
    List<VehicleModel>? vehicles,
    bool? hasMore,
    bool? isLoadingMore,
    DateTime? lastUpdated,
  }) {
    return VehicleLoaded(
      vehicles: vehicles ?? this.vehicles,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class VehicleDetailLoaded extends VehicleState {
  final VehicleModel vehicle;
  final DateTime lastUpdated;

  const VehicleDetailLoaded({
    required this.vehicle,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [vehicle, lastUpdated];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object> get props => [message];
}

class VehicleOperationSuccess extends VehicleState {
  final String message;

  const VehicleOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class VehicleOperationFailure extends VehicleState {
  final String message;

  const VehicleOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}