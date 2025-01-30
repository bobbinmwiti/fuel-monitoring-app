import 'package:get_it/get_it.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/pdf_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  getIt.registerSingleton<LocationService>(LocationService());
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<PdfService>(PdfService());
  
  // Initialize services
  await getIt<NotificationService>().initialize();
  await getIt<LocationService>().initialize();
}
