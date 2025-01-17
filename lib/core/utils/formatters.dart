// lib/core/utils/formatters.dart
import 'package:intl/intl.dart' as intl;

class Formatters {
  // Date Formatters
  static String formatDate(DateTime date) {
    final formatter = intl.DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    final formatter = intl.DateFormat('dd MMM yyyy, HH:mm');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime time) {
    final formatter = intl.DateFormat('HH:mm');
    return formatter.format(time);
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(date);
    }
  }

  // Currency and Number Formatters
  static String formatCurrency(double amount) {
    final formatter = intl.NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatNumber(double number) {
    final formatter = intl.NumberFormat('#,##0.00');
    return formatter.format(number);
  }

  static String formatCompactNumber(num number) {
    final formatter = intl.NumberFormat.compact();
    return formatter.format(number);
  }

  // Fuel Related Formatters
  static String formatFuelVolume(double liters) {
    final formattedNumber = formatNumber(liters);
    return '$formattedNumber L';
  }

  static String formatFuelEfficiency(double kmPerLiter) {
    final formattedNumber = formatNumber(kmPerLiter);
    return '$formattedNumber km/L';
  }

  static String formatFuelCost(double cost) {
    return formatCurrency(cost);
  }

  // Distance and Speed Formatters
  static String formatDistance(double kilometers) {
    if (kilometers >= 1000) {
      final formattedNumber = formatNumber(kilometers / 1000);
      return '$formattedNumber km';
    }
    final formattedNumber = formatNumber(kilometers);
    return '$formattedNumber m';
  }

  static String formatSpeed(double kmPerHour) {
    final formattedNumber = formatNumber(kmPerHour);
    return '$formattedNumber km/h';
  }

  // Percentage Formatter
  static String formatPercentage(double percentage) {
    final formatter = intl.NumberFormat('#,##0.0');
    return '${formatter.format(percentage)}%';
  }

  // Vehicle Formatters
  static String formatLicensePlate(String plate) {
    return plate.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String formatOdometer(int kilometers) {
    final formatter = intl.NumberFormat('#,##0');
    return '${formatter.format(kilometers)} km';
  }

  // Duration Formatter
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }

  // Size Formatter
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Phone Number Formatter
  static String formatPhoneNumber(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length >= 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6, 10)}';
    }
    return phoneNumber;
  }
}