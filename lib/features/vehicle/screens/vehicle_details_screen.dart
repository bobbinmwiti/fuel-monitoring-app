// lib/features/vehicle/screens/vehicle_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/real_time_fuel_monitor.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String vehicleId;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late ScaffoldMessengerState _scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(LoadVehicleDetails(widget.vehicleId));
    context.read<VehicleBloc>().add(WatchVehicle(widget.vehicleId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    context.read<VehicleBloc>().add(const StopWatchingVehicle());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit vehicle screen
              // Navigator.pushNamed(context, '/edit-vehicle', arguments: widget.vehicleId);
            },
          ),
        ],
      ),
      body: BlocListener<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state is VehicleOperationSuccess) {
            _scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.message.contains('deleted')) {
              Navigator.pop(context);
            }
          }
          if (state is VehicleOperationFailure) {
            _scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VehicleError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Vehicle',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Try Again',
                        onPressed: () {
                          context
                              .read<VehicleBloc>()
                              .add(LoadVehicleDetails(widget.vehicleId));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is VehicleDetailLoaded) {
              final vehicle = state.vehicle;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RealTimeFuelMonitor(vehicleId: widget.vehicleId),
                    const SizedBox(height: 16),

                    VehicleCard(
                      vehicle: vehicle,
                      showActions: false,
                    ),
                    const SizedBox(height: 24),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle Information',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem('Make', vehicle.make),
                          _buildDetailItem('Model', vehicle.model),
                          _buildDetailItem('Year', vehicle.year.toString()),
                          _buildDetailItem('Fuel Type', vehicle.fuelType),
                          _buildDetailItem(
                            'Fuel Capacity',
                            '${vehicle.fuelCapacity.toString()} L',
                          ),
                          _buildDetailItem(
                            'Current Odometer',
                            Formatters.formatOdometer(vehicle.currentOdometer),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (vehicle.lastMaintenance != null) ...[
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Maintenance',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            _buildDetailItem(
                              'Last Maintenance',
                              Formatters.formatDate(vehicle.lastMaintenance!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Add Fuel Record',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/add-fuel-record',
                                arguments: vehicle,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        CustomButton(
                          text: 'View History',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/fuel-history',
                              arguments: vehicle,
                            );
                          },
                          isOutlined: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Delete Vehicle',
                      onPressed: () => _confirmDelete(context, vehicle.name),
                      isOutlined: true,
                      backgroundColor: AppColors.error.withAlpha(25),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String vehicleName) async {
    final vehicleBloc = context.read<VehicleBloc>();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text(
          'Are you sure you want to delete $vehicleName? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      vehicleBloc.add(DeleteVehicle(widget.vehicleId));
    }
  }
}