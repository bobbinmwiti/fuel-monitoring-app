// lib/features/vehicle/widgets/vehicle_card.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../core/utils/formatters.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showActions;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getVehicleIcon(),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.name,
                      style: AppTextStyles.titleLarge,
                    ),
                    Text(
                      vehicle.licensePlate,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (showActions)
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          Icon(Icons.info_outline),
                          SizedBox(width: 8),
                          Text('Details'),
                        ],
                      ),
                    ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppColors.error),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'details':
                        onTap?.call();
                        break;
                      case 'delete':
                        _confirmDelete(context);
                        break;
                    }
                  },
                ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                'Fuel Level',
                '${(vehicle.currentFuelLevel / vehicle.fuelCapacity * 100).toStringAsFixed(1)}%',
                Icons.local_gas_station,
                _getFuelLevelColor(),
              ),
              _buildInfoItem(
                'Last Updated',
                Formatters.formatRelativeDate(vehicle.updatedAt),
                Icons.update,
                AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: vehicle.currentFuelLevel / vehicle.fuelCapacity,
            backgroundColor: AppColors.textSecondary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_getFuelLevelColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getVehicleIcon() {
    // Add more vehicle type checks if needed
    return Icons.directions_car;
  }

  Color _getFuelLevelColor() {
    final percentage = (vehicle.currentFuelLevel / vehicle.fuelCapacity) * 100;
    if (percentage <= 20) {
      return AppColors.error;
    } else if (percentage <= 40) {
      return AppColors.warning;
    }
    return AppColors.success;
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete ${vehicle.name}?'),
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

    if (confirmed == true) {
      onDelete?.call();
    }
  }
}