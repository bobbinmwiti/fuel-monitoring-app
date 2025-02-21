// lib/features/fuel_tracking/screens/fuel_entry_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/models/fuel_record_model.dart';
import '../../../data/models/vehicle_model.dart';
import '../bloc/fuel_bloc.dart';
import '../bloc/fuel_event.dart';
import '../bloc/fuel_state.dart';

class FuelEntryScreen extends StatefulWidget {
  final VehicleModel vehicle;

  const FuelEntryScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends State<FuelEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fuelAmountController = TextEditingController();
  final _costPerLiterController = TextEditingController();
  final _odometerController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _fillingDate = DateTime.now();

  double get _totalCost {
    final amount = double.tryParse(_fuelAmountController.text) ?? 0;
    final costPerLiter = double.tryParse(_costPerLiterController.text) ?? 0;
    return amount * costPerLiter;
  }

  @override
  void dispose() {
    _fuelAmountController.dispose();
    _costPerLiterController.dispose();
    _odometerController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
   if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final fuelRecord = FuelRecordModel(
        id: const Uuid().v4(),
        vehicleId: widget.vehicle.id,
        userId: user.uid,
        fuelAmount: double.parse(_fuelAmountController.text),
        costPerLiter: double.parse(_costPerLiterController.text),
        totalCost: _totalCost,
        odometerReading: int.parse(_odometerController.text),
        fillingDate: _fillingDate,
        location: _locationController.text,
        notes: _notesController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ); 

      context.read<FuelBloc>().add(AddFuelRecord(fuelRecord));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fillingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _fillingDate) {
      setState(() {
        _fillingDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Fuel Record'),
      ),
      body: BlocListener<FuelBloc, FuelState>(
        listener: (context, state) {
          if (state is FuelOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25), // 10% opacity
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vehicle.name,
                                  style: AppTextStyles.titleLarge,
                                ),
                                Text(
                                  widget.vehicle.licensePlate,
                                  style: AppTextStyles.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        'Current Fuel Level: ${widget.vehicle.currentFuelLevel.toStringAsFixed(1)}L / ${widget.vehicle.fuelCapacity}L',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _fuelAmountController,
                        decoration: const InputDecoration(
                          labelText: 'Fuel Amount (L)',
                          prefixIcon: Icon(Icons.local_gas_station),
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.validateFuelAmount,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _costPerLiterController,
                        decoration: const InputDecoration(
                          labelText: 'Cost per Liter',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.validateFuelAmount,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25), // 10% opacity
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Cost:',
                              style: AppTextStyles.bodyLarge,
                            ),
                            Text(
                              Formatters.formatCurrency(_totalCost),
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _odometerController,
                        decoration: const InputDecoration(
                          labelText: 'Odometer Reading',
                          prefixIcon: Icon(Icons.speed),
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.validateMileage,
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Filling Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            Formatters.formatDate(_fillingDate),
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location (Optional)',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (Optional)',
                          prefixIcon: Icon(Icons.note),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<FuelBloc, FuelState>(
                  builder: (context, state) {
                    final isLoading = state is FuelLoading;
                    return CustomButton(
                      text: 'Save Record',
                      onPressed: _submitForm,
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}