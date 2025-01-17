// lib/features/dashboard/bloc/dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_monitoring_app/data/repositories/fuel_record_repository.dart';
import 'package:fuel_monitoring_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:fuel_monitoring_app/features/dashboard/bloc/dashboard_state.dart';
import '../../../data/repositories/vehicle_repository.dart';




class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final VehicleRepository _vehicleRepository;
  final FuelRecordRepository _fuelRecordRepository;
  static const int _pageSize = 10;
  DocumentSnapshot? _lastVehicleDocument;
  DocumentSnapshot? _lastFuelRecordDocument;

  DashboardBloc({
    required VehicleRepository vehicleRepository,
    required FuelRecordRepository fuelRecordRepository,
  })  : _vehicleRepository = vehicleRepository,
        _fuelRecordRepository = fuelRecordRepository,
        super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<LoadMoreVehicles>(_onLoadMoreVehicles);
    on<LoadMoreFuelRecords>(_onLoadMoreFuelRecords);
    on<UpdateDashboardStats>(_onUpdateDashboardStats);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoading());

      final vehicleResult = await _vehicleRepository.getVehicles(
        limit: _pageSize,
      );

      _lastVehicleDocument = vehicleResult.lastDocument;
      final vehicles = vehicleResult.vehicles;

      final vehiclesNeedingRefuel = 
          await _vehicleRepository.getVehiclesNeedingRefuel();

      final fuelRecordResult = 
          await _fuelRecordRepository.getRecentFuelRecords(
        limit: _pageSize,
      );

      _lastFuelRecordDocument = fuelRecordResult.lastDocument;
      final recentFuelRecords = fuelRecordResult.records;

      emit(DashboardLoaded(
        vehicles: vehicles,
        vehiclesNeedingRefuel: vehiclesNeedingRefuel,
        recentFuelRecords: recentFuelRecords,
        hasMoreVehicles: vehicles.length >= _pageSize,
        hasMoreRecords: recentFuelRecords.length >= _pageSize,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      _lastVehicleDocument = null;
      _lastFuelRecordDocument = null;

      final vehicleResult = await _vehicleRepository.getVehicles(
        limit: _pageSize,
      );

      _lastVehicleDocument = vehicleResult.lastDocument;
      final vehicles = vehicleResult.vehicles;

      final vehiclesNeedingRefuel = 
          await _vehicleRepository.getVehiclesNeedingRefuel();

      final fuelRecordResult = 
          await _fuelRecordRepository.getRecentFuelRecords(
        limit: _pageSize,
      );

      _lastFuelRecordDocument = fuelRecordResult.lastDocument;
      final recentFuelRecords = fuelRecordResult.records;

      emit(DashboardLoaded(
        vehicles: vehicles,
        vehiclesNeedingRefuel: vehiclesNeedingRefuel,
        recentFuelRecords: recentFuelRecords,
        hasMoreVehicles: vehicles.length >= _pageSize,
        hasMoreRecords: recentFuelRecords.length >= _pageSize,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadMoreVehicles(
    LoadMoreVehicles event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    
    if (!currentState.hasMoreVehicles || currentState.isLoadingMore) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final vehicleResult = await _vehicleRepository.getVehicles(
        limit: _pageSize,
        startAfter: _lastVehicleDocument,
      );

      _lastVehicleDocument = vehicleResult.lastDocument;
      final moreVehicles = vehicleResult.vehicles;

      emit(currentState.copyWith(
        vehicles: [...currentState.vehicles, ...moreVehicles],
        hasMoreVehicles: moreVehicles.length >= _pageSize,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadMoreFuelRecords(
    LoadMoreFuelRecords event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    if (!currentState.hasMoreRecords || currentState.isLoadingMore) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final fuelRecordResult = await _fuelRecordRepository.getRecentFuelRecords(
        limit: _pageSize,
        startAfter: _lastFuelRecordDocument,
      );

      _lastFuelRecordDocument = fuelRecordResult.lastDocument;
      final moreRecords = fuelRecordResult.records;

      emit(currentState.copyWith(
        recentFuelRecords: [...currentState.recentFuelRecords, ...moreRecords],
        hasMoreRecords: moreRecords.length >= _pageSize,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onUpdateDashboardStats(
    UpdateDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    try {
      final vehiclesNeedingRefuel = 
          await _vehicleRepository.getVehiclesNeedingRefuel();

      emit(currentState.copyWith(
        vehiclesNeedingRefuel: vehiclesNeedingRefuel,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}

