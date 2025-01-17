// lib/features/dashboard/bloc/dashboard_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/fuel_record_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<VehicleModel> vehicles;
  final List<VehicleModel> vehiclesNeedingRefuel;
  final List<FuelRecordModel> recentFuelRecords;
  final bool isLoadingMore;
  final bool hasMoreVehicles;
  final bool hasMoreRecords;
  final DateTime lastUpdated;

  const DashboardLoaded({
    required this.vehicles,
    required this.vehiclesNeedingRefuel,
    required this.recentFuelRecords,
    this.isLoadingMore = false,
    this.hasMoreVehicles = true,
    this.hasMoreRecords = true,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        vehicles,
        vehiclesNeedingRefuel,
        recentFuelRecords,
        isLoadingMore,
        hasMoreVehicles,
        hasMoreRecords,
        lastUpdated,
      ];

  DashboardLoaded copyWith({
    List<VehicleModel>? vehicles,
    List<VehicleModel>? vehiclesNeedingRefuel,
    List<FuelRecordModel>? recentFuelRecords,
    bool? isLoadingMore,
    bool? hasMoreVehicles,
    bool? hasMoreRecords,
    DateTime? lastUpdated,
  }) {
    return DashboardLoaded(
      vehicles: vehicles ?? this.vehicles,
      vehiclesNeedingRefuel: vehiclesNeedingRefuel ?? this.vehiclesNeedingRefuel,
      recentFuelRecords: recentFuelRecords ?? this.recentFuelRecords,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreVehicles: hasMoreVehicles ?? this.hasMoreVehicles,
      hasMoreRecords: hasMoreRecords ?? this.hasMoreRecords,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardLoadingMore extends DashboardState {
  final DashboardLoaded currentState;

  const DashboardLoadingMore(this.currentState);

  @override
  List<Object?> get props => [currentState];
}