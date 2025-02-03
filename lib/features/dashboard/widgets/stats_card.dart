// lib/features/dashboard/widgets/stats_card.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/fuel_record_model.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final List<Widget> children;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    required this.children,
    this.onTap,
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
                  color: (color ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color ?? AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleLarge,
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // Factory constructor for vehicle stats
  static Widget vehicleStats({
    required VehicleModel vehicle,
    required List<FuelRecordModel> fuelRecords,
    VoidCallback? onTap,
  }) {
    final totalFuel = fuelRecords.fold<double>(
      0,
      (sum, record) => sum + record.fuelAmount,
    );

    final totalCost = fuelRecords.fold<double>(
      0,
      (sum, record) => sum + record.totalCost,
    );

    return StatsCard(
      title: vehicle.name,
      icon: Icons.directions_car,
      onTap: onTap,
      children: [
        Row(
          children: [
            _buildStatItem(
              'Fuel Level',
              Formatters.formatPercentage(
                (vehicle.currentFuelLevel / vehicle.fuelCapacity) * 100,
              ),
              Icons.local_gas_station,
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              'Total Fuel',
              Formatters.formatFuelVolume(totalFuel),
              Icons.opacity,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatItem(
              'Total Cost',
              Formatters.formatCurrency(totalCost),
              Icons.payments,
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              'Records',
              fuelRecords.length.toString(),
              Icons.receipt_long,
            ),
          ],
        ),
      ],
    );
  }

  // Factory constructor for performance stats
  static Widget performanceStats({
    required List<FuelRecordModel> fuelRecords,
    VoidCallback? onTap,
  }) {
    final averageEfficiency = fuelRecords.isEmpty
        ? 0.0
        : fuelRecords.fold<double>(
            0,
            (sum, record) => sum + record.fuelEfficiency,
          ) /
            fuelRecords.length;

    return StatsCard(
      title: 'Performance',
      icon: Icons.speed,
      color: AppColors.secondary,
      onTap: onTap,
      children: [
        Row(
          children: [
            _buildStatItem(
              'Avg Efficiency',
              Formatters.formatFuelEfficiency(averageEfficiency),
              Icons.trending_up,
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              'Records',
              fuelRecords.length.toString(),
              Icons.receipt_long,
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}