import '../domain.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(
    String email,
    String password,
    String nombre,
    String apellido,
  );
  Future<User> checkAuthStatus(String token);
}
