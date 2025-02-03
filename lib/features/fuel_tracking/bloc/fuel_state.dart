// lib/features/fuel_tracking/bloc/fuel_state.dart

import 'package:equatable/equatable.dart';
import '../../../data/models/fuel_record_model.dart';

abstract class FuelState extends Equatable {
  const FuelState();

  @override
  List<Object?> get props => [];
}

class FuelInitial extends FuelState {
  const FuelInitial();
}

class FuelLoading extends FuelState {
  const FuelLoading();
}

class FuelLoaded extends FuelState {
  final List<FuelRecordModel> records;
  final bool hasMoreRecords;
  final bool isLoadingMore;
  final DateTime lastUpdated;
  final String? vehicleId;
  final Map<String, dynamic>? statistics;

  const FuelLoaded({
    required this.records,
    this.hasMoreRecords = true,
    this.isLoadingMore = false,
    required this.lastUpdated,
    this.vehicleId,
    this.statistics,
  });

  @override
  List<Object?> get props => [
        records,
        hasMoreRecords,
        isLoadingMore,
        lastUpdated,
        vehicleId,
        statistics,
      ];

  FuelLoaded copyWith({
    List<FuelRecordModel>? records,
    bool? hasMoreRecords,
    bool? isLoadingMore,
    DateTime? lastUpdated,
    String? vehicleId,
    Map<String, dynamic>? statistics,
  }) {
    return FuelLoaded(
      records: records ?? this.records,
      hasMoreRecords: hasMoreRecords ?? this.hasMoreRecords,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      vehicleId: vehicleId ?? this.vehicleId,
      statistics: statistics ?? this.statistics,
    );
  }
}

class FuelError extends FuelState {
  final String message;

  const FuelError(this.message);

  @override
  List<Object> get props => [message];
}

class FuelOperationSuccess extends FuelState {
  final String message;

  const FuelOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class FuelOperationFailure extends FuelState {
  final String message;

  const FuelOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}