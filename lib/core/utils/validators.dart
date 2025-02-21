// lib/core/utils/validators.dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*()_+=-{};:"<>,.?/~]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateVehiclePlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle plate is required';
    }
    final plateRegex = RegExp(r'^[A-Z0-9 -]+$');
    if (!plateRegex.hasMatch(value)) {
      return 'Please enter a valid vehicle plate';
    }
    return null;
  }

  static String? validateFuelAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fuel amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  static String? validateMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mileage is required';
    }
    final mileage = double.tryParse(value);
    if (mileage == null) {
      return 'Please enter a valid number';
    }
    if (mileage < 0) {
      return 'Mileage cannot be negative';
    }
    return null;
  }
}