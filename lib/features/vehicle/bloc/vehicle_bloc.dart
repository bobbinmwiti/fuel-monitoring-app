// lib/features/vehicle/bloc/vehicle_bloc.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/vehicle_repository.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository _vehicleRepository;
  StreamSubscription? _vehicleSubscription;
  DocumentSnapshot? _lastDocument;
  static const int _pageSize = 10;

  VehicleBloc({
    required VehicleRepository vehicleRepository,
  })  : _vehicleRepository = vehicleRepository,
        super(const VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<LoadMoreVehicles>(_onLoadMoreVehicles);
    on<LoadVehicleDetails>(_onLoadVehicleDetails);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
    on<RefreshVehicles>(_onRefreshVehicles);
    on<WatchVehicle>(_onWatchVehicle);
    on<StopWatchingVehicle>(_onStopWatchingVehicle);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      emit(const VehicleLoading());

      final result = await _vehicleRepository.getVehicles(
        limit: event.limit,
      );

      _lastDocument = result.lastDocument;

      emit(VehicleLoaded(
        vehicles: result.vehicles,
        hasMore: result.lastDocument != null,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onLoadMoreVehicles(
    LoadMoreVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VehicleLoaded) return;
    if (!currentState.hasMore || currentState.isLoadingMore || _lastDocument == null) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final result = await _vehicleRepository.getVehicles(
        limit: _pageSize,
        startAfter: _lastDocument,
      );

      _lastDocument = result.lastDocument;

      emit(currentState.copyWith(
        vehicles: [...currentState.vehicles, ...result.vehicles],
        hasMore: result.lastDocument != null,
        isLoadingMore: false,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onLoadVehicleDetails(
    LoadVehicleDetails event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      emit(const VehicleLoading());

      final vehicle = await _vehicleRepository.getVehicleById(event.vehicleId);
      
      if (vehicle != null) {
        emit(VehicleDetailLoaded(
          vehicle: vehicle,
          lastUpdated: DateTime.now(),
        ));
      } else {
        emit(const VehicleError('Vehicle not found'));
      }
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onAddVehicle(
    AddVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await _vehicleRepository.createVehicle(event.vehicle);
      emit(const VehicleOperationSuccess('Vehicle added successfully'));

      // Refresh the list if we're in loaded state
      if (state is VehicleLoaded) {
        add(const LoadVehicles());
      }
    } catch (e) {
      emit(VehicleOperationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await _vehicleRepository.updateVehicle(event.id, event.data);
      emit(const VehicleOperationSuccess('Vehicle updated successfully'));

      // Refresh current state
      final currentState = state;
      if (currentState is VehicleDetailLoaded) {
        add(LoadVehicleDetails(event.id));
      } else if (currentState is VehicleLoaded) {
        add(const LoadVehicles());
      }
    } catch (e) {
      emit(VehicleOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await _vehicleRepository.deleteVehicle(event.id);
      emit(const VehicleOperationSuccess('Vehicle deleted successfully'));

      if (state is VehicleLoaded) {
        add(const LoadVehicles());
      }
    } catch (e) {
      emit(VehicleOperationFailure(e.toString()));
    }
  }

  Future<void> _onRefreshVehicles(
    RefreshVehicles event,
    Emitter<VehicleState> emit,
  ) async {
    add(const LoadVehicles(limit: _pageSize));
  }

  Future<void> _onWatchVehicle(
    WatchVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    _vehicleSubscription?.cancel();
    _vehicleSubscription = _vehicleRepository
        .streamVehicle(event.id)
        .listen((vehicle) {
          if (vehicle != null) {
            emit(VehicleDetailLoaded(
              vehicle: vehicle,
              lastUpdated: DateTime.now(),
            ));
          }
        });
  }

  Future<void> _onStopWatchingVehicle(
    StopWatchingVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    await _vehicleSubscription?.cancel();
    _vehicleSubscription = null;
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    return super.close();
  }
}