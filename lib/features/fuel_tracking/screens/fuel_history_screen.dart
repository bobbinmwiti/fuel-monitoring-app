// lib/features/fuel_tracking/screens/fuel_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/models/vehicle_model.dart';
import '../bloc/fuel_bloc.dart';
import '../bloc/fuel_event.dart';
import '../bloc/fuel_state.dart';
import '../widgets/fuel_history_card.dart';

class FuelHistoryScreen extends StatefulWidget {
  final VehicleModel? vehicle;

  const FuelHistoryScreen({
    super.key,
    this.vehicle,
  });

  @override
  State<FuelHistoryScreen> createState() => _FuelHistoryScreenState();
}

class _FuelHistoryScreenState extends State<FuelHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<FuelBloc>().add(
          LoadFuelRecords(vehicleId: widget.vehicle?.id),
        );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FuelBloc>().add(
            LoadMoreFuelRecords(vehicleId: widget.vehicle?.id),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.vehicle != null ? '${widget.vehicle!.name} History' : 'Fuel History',
        ),
      ),
      body: BlocConsumer<FuelBloc, FuelState>(
        listener: (context, state) {
          if (state is FuelOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is FuelOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FuelLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FuelError) {
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
                      'Error Loading Records',
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
                    ElevatedButton(
                      onPressed: () => context.read<FuelBloc>().add(
                            LoadFuelRecords(vehicleId: widget.vehicle?.id),
                          ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FuelLoaded) {
            if (state.records.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_gas_station_outlined,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Fuel Records',
                        style: AppTextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start by adding your first fuel record',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FuelBloc>().add(
                      RefreshFuelRecords(vehicleId: widget.vehicle?.id),
                    );
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  if (state.statistics != null) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomCard(
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
                                    child: const Icon(
                                      Icons.analytics,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Statistics',
                                    style: AppTextStyles.titleLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildStatRow(
                                'Total Fuel',
                                Formatters.formatFuelVolume(
                                  state.statistics!['totalFuel'],
                                ),
                                Icons.local_gas_station,
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                'Total Cost',
                                Formatters.formatCurrency(
                                  state.statistics!['totalCost'],
                                ),
                                Icons.payments,
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                'Average Cost',
                                Formatters.formatCurrency(
                                  state.statistics!['averageCost'],
                                ),
                                Icons.trending_up,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.records.length) {
                            return state.hasMoreRecords && state.isLoadingMore
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : null;
                          }

                          final record = state.records[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: FuelHistoryCard(
                              record: record,
                              onDelete: () {
                                context.read<FuelBloc>().add(
                                      DeleteFuelRecord(record.id),
                                    );
                              },
                            ),
                          );
                        },
                        childCount: state.hasMoreRecords && state.isLoadingMore
                            ? state.records.length + 1
                            : state.records.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.titleLarge,
        ),
      ],
    );
  }
}