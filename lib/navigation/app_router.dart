// lib/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/email_verification_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/bloc/dashboard_bloc.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/repositories/fuel_record_repository.dart';

class AppRouter {
  // Route names
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );

      case verifyEmail:
        if (settings.arguments is! String) {
          return _errorRoute('Email argument is required');
        }
        return MaterialPageRoute(
          builder: (_) => EmailVerificationScreen(
            email: settings.arguments as String,
          ),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => DashboardBloc(
              vehicleRepository: VehicleRepository(),
              fuelRecordRepository: FuelRecordRepository(),
            ),
            child: const DashboardScreen(),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute([String? message]) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message ?? 'Route not found!',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to check if route needs authentication
  static bool requiresAuth(String route) {
    return route == dashboard;
  }
}