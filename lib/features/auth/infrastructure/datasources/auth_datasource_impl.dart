import 'package:jbre_app/config/config.dart';
import 'package:jbre_app/features/auth/domain/domain.dart';
import 'package:jbre_app/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final HttpAdapter httpAdapter;

  AuthDataSourceImpl({HttpAdapter? httpAdapter})
    : httpAdapter = httpAdapter ?? DioHttpAdapter(baseUrl: Environment.apiUrl);

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
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
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
