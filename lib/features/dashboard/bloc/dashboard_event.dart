// lib/features/dashboard/bloc/dashboard_event.dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class LoadMoreVehicles extends DashboardEvent {
  const LoadMoreVehicles();
}

class LoadMoreFuelRecords extends DashboardEvent {
  const LoadMoreFuelRecords();
}

class UpdateDashboardStats extends DashboardEvent {
  const UpdateDashboardStats();
}