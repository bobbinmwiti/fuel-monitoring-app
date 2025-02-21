// lib/features/fuel_tracking/widgets/fuel_entry_form.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/vehicle_model.dart';

class FuelEntryForm extends StatefulWidget {
  final VehicleModel vehicle;
  final Function(Map<String, dynamic> formData) onSubmit;
  final bool isLoading;

  const FuelEntryForm({
    super.key,
    required this.vehicle,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<FuelEntryForm> createState() => _FuelEntryFormState();
}

class _FuelEntryFormState extends State<FuelEntryForm> {
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
      widget.onSubmit({
        'fuelAmount': double.parse(_fuelAmountController.text),
        'costPerLiter': double.parse(_costPerLiterController.text),
        'totalCost': _totalCost,
        'odometerReading': int.parse(_odometerController.text),
        'fillingDate': _fillingDate,
        'location': _locationController.text,
        'notes': _notesController.text,
      });
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildVehicleInfo(),
          const SizedBox(height: 24),
          _buildFuelDetails(),
          const SizedBox(height: 24),
          _buildAdditionalDetails(),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Save Record',
            onPressed: _submitForm,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
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
    );
  }

  Widget _buildFuelDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fuel Details',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fuelAmountController,
            decoration: const InputDecoration(
              labelText: 'Fuel Amount (L)',
              prefixIcon: Icon(Icons.local_gas_station),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            validator: Validators.validateFuelAmount,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
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
        ],
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Details',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _odometerController,
            decoration: const InputDecoration(
              labelText: 'Odometer Reading',
              prefixIcon: Icon(Icons.speed),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
    );
  }
}