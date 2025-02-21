// lib/features/dashboard/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/fuel_summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<DashboardBloc>().add(const LoadDashboard());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<DashboardBloc>().state;
      if (state is DashboardLoaded) {
        if (state.hasMoreVehicles) {
          context.read<DashboardBloc>().add(const LoadMoreVehicles());
        }
        if (state.hasMoreRecords) {
          context.read<DashboardBloc>().add(const LoadMoreFuelRecords());
        }
      }
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const RefreshDashboard());
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial || state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardError) {
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
                        'Error loading dashboard',
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
                        onPressed: () {
                          context.read<DashboardBloc>().add(const LoadDashboard());
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is DashboardLoaded) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: true,
                    backgroundColor: AppColors.primary,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Dashboard',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      background: Container(
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (state.vehiclesNeedingRefuel.isNotEmpty) ...[
                          Text(
                            'Vehicles Needing Refuel',
                            style: AppTextStyles.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.vehiclesNeedingRefuel.length,
                              itemBuilder: (context, index) {
                                final vehicle = state.vehiclesNeedingRefuel[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index < state.vehiclesNeedingRefuel.length - 1 ? 16 : 0,
                                  ),
                                  child: SizedBox(
                                    width: 300,
                                    child: StatsCard.vehicleStats(
                                      vehicle: vehicle,
                                      fuelRecords: state.recentFuelRecords
                                          .where((r) => r.vehicleId == vehicle.id)
                                          .toList(),
                                      onTap: () {
                                        // Navigate to vehicle details
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        FuelSummaryCard(
                          fuelRecords: state.recentFuelRecords,
                          startDate: DateTime.now().subtract(const Duration(days: 30)),
                          endDate: DateTime.now(),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Records',
                              style: AppTextStyles.headlineMedium,
                            ),
                            Text(
                              '${state.recentFuelRecords.length} records',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        ...state.recentFuelRecords.map((record) {
                          final vehicle = state.vehicles.firstWhere(
                            (v) => v.id == record.vehicleId,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CustomCard(
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withAlpha(25), // 0.1 opacity
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.local_gas_station,
                                    color: AppColors.primary,
                                  ),
                                ),
                                title: Text(vehicle.name),
                                subtitle: Text(
                                  '${record.fuelAmount.toStringAsFixed(1)}L • \$${record.totalCost.toStringAsFixed(2)}',
                                ),
                                trailing: Text(
                                  record.fillingDate.toString().split(' ')[0],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        if (state.isLoadingMore) ...[
                          const SizedBox(height: 16),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ]),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}