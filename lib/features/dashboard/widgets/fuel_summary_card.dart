// lib/features/dashboard/widgets/fuel_summary_card.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/models/fuel_record_model.dart';

class FuelSummaryCard extends StatelessWidget {
  final List<FuelRecordModel> fuelRecords;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onTap;

  const FuelSummaryCard({
    super.key,
    required this.fuelRecords,
    required this.startDate,
    required this.endDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalFuel = fuelRecords.fold<double>(
      0,
      (sum, record) => sum + record.fuelAmount,
    );

    final totalCost = fuelRecords.fold<double>(
      0,
      (sum, record) => sum + record.totalCost,
    );

    final averageCost = fuelRecords.isEmpty
        ? 0.0
        : totalCost / fuelRecords.length;

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
                  color: AppColors.primary.withAlpha(25), // 0.1 opacity (255 * 0.1 ≈ 25)
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_gas_station,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fuel Summary',
                      style: AppTextStyles.titleLarge,
                    ),
                    Text(
                      '${Formatters.formatDate(startDate)} - ${Formatters.formatDate(endDate)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total Fuel',
                  Formatters.formatFuelVolume(totalFuel),
                  Icons.opacity,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  'Total Cost',
                  Formatters.formatCurrency(totalCost),
                  Icons.payments,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Average Cost',
                  Formatters.formatCurrency(averageCost),
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  'Records',
                  fuelRecords.length.toString(),
                  Icons.receipt_long,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Container(
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
    );
  }
}
