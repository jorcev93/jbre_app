import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  
  static initEnvironment () async{
    await dotenv.load(fileName: apiUrl);
  }

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'No se ha configurado el API_URL';
}
