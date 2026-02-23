//! 1 - Creamos el estado - State de este provider (NotifierProvider)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:jbre_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:jbre_app/features/shared/shared.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  const LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  //# Copywith permite crear nuevos estados basados en el estado actual
  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    //! Si no se proporciona un valor, se mantiene el valor actual
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  String toString() {
    return '''
LoginFormState:
  isPosting: $isPosting
  isFormPosted: $isFormPosted
  isValid: $isValid
  email: $email
  password: $password
''';
  }
}

//! 2 - Como implementamos el notifier
class LoginFormNotifier extends Notifier<LoginFormState> {
  late final Function(String, String) loginUserCallback;

  @override
  LoginFormState build() {
    loginUserCallback = ref.watch(authProvider.notifier).loginUser;
    //! Inicializamos el estado con el estado inicial
    return const LoginFormState();
  }

  void onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isFormPosted: false,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isFormPosted: false,
      isValid: Formz.validate([state.email, newPassword]),
    );
  }

  Future<void> onFormSubmitted() async {  
    _touchEveryField();
    if (!state.isValid) return;
    await loginUserCallback(state.email.value, state.password.value);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isPosting: true,
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}

//! 3 - NotifierProvider - consume afuera
final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(
  LoginFormNotifier.new,
);
