import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbre_app/features/auth/domain/domain.dart';
import 'package:jbre_app/features/auth/infrastructure/infraestructure.dart';

import '../../../shared/infrastructure/infraestructure.dart';

//! Provider para el repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final keyValueStorageProvider = Provider<KeyValueStorageService>((ref) {
  return KeyValueStorageServiceImpl();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository authRepository;
  late final KeyValueStorageService keyValueStorageService;

  @override
  AuthState build() {
    authRepository = ref.read(authRepositoryProvider);
    keyValueStorageService = ref.read(keyValueStorageProvider);

    // Verificar estado de autenticación después de crear el notifier
    checkAuthStatus();

    return AuthState();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Limpiamos el error antes de empezar el login
    state = state.copyWith(errorMessage: '');

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado: ${e.runtimeType} - $e');
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String fullName,
  ) async {}

  void checkAuthStatus() async {
    print('\x1B[32m=== checkAuthStatus CALLED ===\x1B[0m');
    final token = await keyValueStorageService.getValue<String>('token');
    print('\x1B[32mTOKEN: $token\x1B[0m');
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      print('\x1B[31mcheckAuthStatus ERROR: $e\x1B[0m');
      logout();
    }
  }

  Future<void> _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage:
          '', // Limpiamos cualquier error previo al autenticarnos exitosamente
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');
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
