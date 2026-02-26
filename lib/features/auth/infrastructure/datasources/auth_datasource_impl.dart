import 'package:jbre_app/config/config.dart';
import 'package:jbre_app/features/auth/domain/domain.dart';
import 'package:jbre_app/features/auth/infrastructure/infraestructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final HttpAdapter httpAdapter;

  AuthDataSourceImpl({HttpAdapter? httpAdapter})
    : httpAdapter = httpAdapter ?? DioHttpAdapter(baseUrl: Environment.apiUrl);

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await httpAdapter.get(
        '/auth/check-status',
        headers: {'Authorization': 'Bearer $token'},
      );

      print('\x1B[32mCHECK-STATUS RESPONSE: ${response.data}\x1B[0m');

      final user = UserMapper.userJsonToEntity(response.data, token: token);
      return user;
    } on HttpAdapterException catch (e) {
      print(
        '\x1B[31mHTTP ERROR: ${e.response?.statusCode} - ${e.response?.data}\x1B[0m',
      );
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      print('\x1B[31mGENERAL ERROR: $e\x1B[0m');
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await httpAdapter.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on HttpAdapterException catch (e) {
      if (e.response != null) {
        throw CustomError(
          e.response?.data?['message'] ?? 'Credenciales incorrectas',
        );
      }
      throw CustomError('Revisar conexión a internet');
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
