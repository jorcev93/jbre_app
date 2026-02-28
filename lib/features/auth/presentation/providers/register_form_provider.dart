import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:jbre_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:jbre_app/features/shared/shared.dart';

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final TextInput nombre;
  final TextInput apellido;
  final Email email;
  final Password password;
  final Password confirmPassword;

  const RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.nombre = const TextInput.pure(),
    this.apellido = const TextInput.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    TextInput? nombre,
    TextInput? apellido,
    Email? email,
    Password? password,
    Password? confirmPassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  String toString() {
    return '''
RegisterFormState:
  isPosting: $isPosting
  isFormPosted: $isFormPosted
  isValid: $isValid
  nombre: $nombre
  apellido: $apellido
  email: $email
  password: $password
  confirmPassword: $confirmPassword
''';
  }
}

class RegisterFormNotifier extends Notifier<RegisterFormState> {
  late final Function(String, String, String, String) registerUserCallback;

  @override
  RegisterFormState build() {
    registerUserCallback = ref.watch(authProvider.notifier).registerUser;
    return const RegisterFormState();
  }

  void onNombreChanged(String value) {
    final nombre = TextInput.dirty(value);
    state = state.copyWith(
      nombre: nombre,
      isFormPosted: false,
      isValid:
          Formz.validate([
            nombre,
            state.apellido,
            state.email,
            state.password,
            state.confirmPassword,
          ]) &&
          state.password.value == state.confirmPassword.value,
    );
  }

  void onApellidoChanged(String value) {
    final apellido = TextInput.dirty(value);
    state = state.copyWith(
      apellido: apellido,
      isFormPosted: false,
      isValid:
          Formz.validate([
            state.nombre,
            apellido,
            state.email,
            state.password,
            state.confirmPassword,
          ]) &&
          state.password.value == state.confirmPassword.value,
    );
  }

  void onEmailChanged(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      isFormPosted: false,
      isValid:
          Formz.validate([
            state.nombre,
            state.apellido,
            email,
            state.password,
            state.confirmPassword,
          ]) &&
          state.password.value == state.confirmPassword.value,
    );
  }

  void onPasswordChanged(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      isFormPosted: false,
      isValid:
          Formz.validate([
            state.nombre,
            state.apellido,
            state.email,
            password,
            state.confirmPassword,
          ]) &&
          password.value == state.confirmPassword.value,
    );
  }

  void onConfirmPasswordChanged(String value) {
    final confirmPassword = Password.dirty(value);
    state = state.copyWith(
      confirmPassword: confirmPassword,
      isFormPosted: false,
      isValid:
          Formz.validate([
            state.nombre,
            state.apellido,
            state.email,
            state.password,
            confirmPassword,
          ]) &&
          state.password.value == confirmPassword.value,
    );
  }

  Future<void> onFormSubmitted() async {
    _touchEveryField();

    // Si no es válido o si las contraseñas no coinciden, abortamos
    if (!state.isValid || state.password.value != state.confirmPassword.value) {
      state = state.copyWith(isPosting: false);
      return;
    }

    state = state.copyWith(isPosting: true);
    await registerUserCallback(
      state.email.value,
      state.password.value,
      state.nombre.value,
      state.apellido.value,
    );
    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final nombre = TextInput.dirty(state.nombre.value);
    final apellido = TextInput.dirty(state.apellido.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    state = state.copyWith(
      isFormPosted: true,
      nombre: nombre,
      apellido: apellido,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isValid:
          Formz.validate([
            nombre,
            apellido,
            email,
            password,
            confirmPassword,
          ]) &&
          password.value == confirmPassword.value,
    );
  }
}

final registerFormProvider =
    NotifierProvider<RegisterFormNotifier, RegisterFormState>(
      RegisterFormNotifier.new,
    );
