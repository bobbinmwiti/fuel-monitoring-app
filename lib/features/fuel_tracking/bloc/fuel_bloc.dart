// lib/features/fuel_tracking/bloc/fuel_bloc.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/fuel_record_repository.dart';
import 'fuel_event.dart';
import 'fuel_state.dart';

class FuelBloc extends Bloc<FuelEvent, FuelState> {
  final FuelRecordRepository _fuelRecordRepository;
  static const int _pageSize = 10;
  DocumentSnapshot? _lastDocument;  // Add this to track the last document
  
  FuelBloc({
    required FuelRecordRepository fuelRecordRepository,
  })  : _fuelRecordRepository = fuelRecordRepository,
        super(const FuelInitial()) {
    on<LoadFuelRecords>(_onLoadFuelRecords);
    on<LoadMoreFuelRecords>(_onLoadMoreFuelRecords);
    on<AddFuelRecord>(_onAddFuelRecord);
    on<UpdateFuelRecord>(_onUpdateFuelRecord);
    on<DeleteFuelRecord>(_onDeleteFuelRecord);
    on<RefreshFuelRecords>(_onRefreshFuelRecords);
  }

  Future<void> _onLoadFuelRecords(
    LoadFuelRecords event,
    Emitter<FuelState> emit,
  ) async {
    try {
      emit(const FuelLoading());

      final result = event.vehicleId != null
          ? await _fuelRecordRepository.getVehicleFuelRecords(
              vehicleId: event.vehicleId!,
              limit: event.limit,
            )
          : await _fuelRecordRepository.getRecentFuelRecords(
              limit: event.limit,
            );

      _lastDocument = result.lastDocument;  // Save the last document

      Map<String, dynamic>? statistics;
      if (event.vehicleId != null) {
        statistics = await _fuelRecordRepository.getVehicleStatistics(
          event.vehicleId!,
        );
      }

      emit(FuelLoaded(
        records: result.records,
        hasMoreRecords: result.lastDocument != null,
        lastUpdated: DateTime.now(),
        vehicleId: event.vehicleId,
        statistics: statistics,
      ));
    } catch (e) {
      emit(FuelError(e.toString()));
    }
  }

  Future<void> _onLoadMoreFuelRecords(
    LoadMoreFuelRecords event,
    Emitter<FuelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FuelLoaded) return;
    if (!currentState.hasMoreRecords || currentState.isLoadingMore || _lastDocument == null) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final result = event.vehicleId != null
          ? await _fuelRecordRepository.getVehicleFuelRecords(
              vehicleId: event.vehicleId!,
              limit: _pageSize,
              startAfter: _lastDocument,  // Use the stored DocumentSnapshot
            )
          : await _fuelRecordRepository.getRecentFuelRecords(
              limit: _pageSize,
              startAfter: _lastDocument,  // Use the stored DocumentSnapshot
            );

      _lastDocument = result.lastDocument;  // Update the last document

      emit(currentState.copyWith(
        records: [...currentState.records, ...result.records],
        hasMoreRecords: result.lastDocument != null,
        isLoadingMore: false,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(FuelError(e.toString()));
    }
  }

  Future<void> _onAddFuelRecord(
    AddFuelRecord event,
    Emitter<FuelState> emit,
  ) async {
    try {
      await _fuelRecordRepository.createFuelRecord(event.record);
      emit(const FuelOperationSuccess('Fuel record added successfully'));
      
      // Reload records if we're in loaded state
      if (state is FuelLoaded) {
        final loadedState = state as FuelLoaded;
        add(LoadFuelRecords(vehicleId: loadedState.vehicleId));
      } else if (state is FuelInitial) {
        add(const LoadFuelRecords());
      }
    } catch (e) {
      emit(FuelOperationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateFuelRecord(
    UpdateFuelRecord event,
    Emitter<FuelState> emit,
  ) async {
    try {
      await _fuelRecordRepository.updateFuelRecord(
        event.id,
        event.data,
      );
      emit(const FuelOperationSuccess('Fuel record updated successfully'));
      
      // Reload records if we're in loaded state
      if (state is FuelLoaded) {
        final loadedState = state as FuelLoaded;
        add(LoadFuelRecords(vehicleId: loadedState.vehicleId));
      } else if (state is FuelInitial) {
        add(const LoadFuelRecords());
      }
    } catch (e) {
      emit(FuelOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteFuelRecord(
    DeleteFuelRecord event,
    Emitter<FuelState> emit,
  ) async {
    try {
      await _fuelRecordRepository.deleteFuelRecord(event.id);
      emit(const FuelOperationSuccess('Fuel record deleted successfully'));
      
      // Reload records if we're in loaded state
      if (state is FuelLoaded) {
        final loadedState = state as FuelLoaded;
        add(LoadFuelRecords(vehicleId: loadedState.vehicleId));
      } else if (state is FuelInitial) {
        add(const LoadFuelRecords());
      }
    } catch (e) {
      emit(FuelOperationFailure(e.toString()));
    }
  }

  Future<void> _onRefreshFuelRecords(
    RefreshFuelRecords event,
    Emitter<FuelState> emit,
  ) async {
    if (state is! FuelLoaded) return;
    
    try {
      final result = event.vehicleId != null
          ? await _fuelRecordRepository.getVehicleFuelRecords(
              vehicleId: event.vehicleId!,
              limit: _pageSize,
            )
          : await _fuelRecordRepository.getRecentFuelRecords(
              limit: _pageSize,
            );

      _lastDocument = result.lastDocument;  // Reset the last document

      Map<String, dynamic>? statistics;
      if (event.vehicleId != null) {
        statistics = await _fuelRecordRepository.getVehicleStatistics(
          event.vehicleId!,
        );
      }

      emit(FuelLoaded(
        records: result.records,
        hasMoreRecords: result.lastDocument != null,
        lastUpdated: DateTime.now(),
        vehicleId: event.vehicleId,
        statistics: statistics,
      ));
    } catch (e) {
      emit(FuelError(e.toString()));
    }
  }

  @override
  void onTransition(Transition<FuelEvent, FuelState> transition) {
    super.onTransition(transition);
    // Add state handling logic here
    if (transition.event is LoadFuelRecords) {
      // Handle LoadFuelRecords event
    } else if (transition.event is LoadMoreFuelRecords) {
      // Handle LoadMoreFuelRecords event
    } else if (transition.event is AddFuelRecord) {
      // Handle AddFuelRecord event
    } else if (transition.event is UpdateFuelRecord) {
      // Handle UpdateFuelRecord event
    } else if (transition.event is DeleteFuelRecord) {
      // Handle DeleteFuelRecord event
    } else if (transition.event is RefreshFuelRecords) {
      // Handle RefreshFuelRecords event
    }
  }
}