import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String get apiUrl =>
      dotenv.env['API_URL'] ?? 'No se ha configurado el API_URL';
}
