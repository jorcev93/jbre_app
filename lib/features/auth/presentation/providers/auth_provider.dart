import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbre_app/config/config.dart';
import 'package:jbre_app/features/auth/domain/domain.dart';
import 'package:jbre_app/features/auth/infrastructure/infraestructure.dart';

//! Provider para el repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository authRepository;

  @override
  AuthState build() {
    authRepository = ref.read(authRepositoryProvider);
    return AuthState();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales incorrectas');
    } on Exception catch (e) {
      if (e is HttpAdapterException) {
        print('Status: ${e.statusCode}, Data: ${e.data}');
      }
      logout('Error no controlado: ${e.runtimeType} - $e');
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String fullName,
  ) async {}
  Future<void> checkAuthStatus(String token) async {}

  void _setLoggedUser(User user) {
    //TODO: guardar token fisicamente
    state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO: limpiar token fisicamente
    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  //! Utilizo copyWith para crear un nuevo estado basado en el estado actual
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
