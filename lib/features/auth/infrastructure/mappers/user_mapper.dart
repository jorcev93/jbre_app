import 'package:jbre_app/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json, {String? token}) {
    final userData = json['user'] as Map<String, dynamic>;
    final persona = userData['persona'] as Map<String, dynamic>;
    final rol = persona['rol'] as Map<String, dynamic>;

    return User(
      id: userData['id'],
      email: userData['email'],
      fullName: '${persona['nombre']} ${persona['apellido']}',
      roles: [rol['nombre']],
      token: json['accessToken'] ?? token ?? '',
    );
  }
}
