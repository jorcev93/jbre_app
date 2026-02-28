import 'package:jbre_app/features/auth/domain/domain.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(
    String email,
    String password,
    String nombre,
    String apellido,
  );
  Future<User> checkAuthStatus(String token);
}
