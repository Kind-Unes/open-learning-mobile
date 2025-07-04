import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}

// For backward compatibility
final String baseUrl = AppConstants.baseUrl;
