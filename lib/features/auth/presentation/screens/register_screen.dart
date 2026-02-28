import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbre_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:jbre_app/features/auth/presentation/providers/register_form_provider.dart';
import 'package:jbre_app/features/shared/widgets/custom_text_form_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0E1711),
        body: Stack(
          children: [
            // Contenido scrollable
            SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: _RegisterForm(),
              ),
            ),

            // Botón de regreso
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/login');
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);
    final size = MediaQuery.of(context).size;

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),

          // Logo
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'assets/images/logo_jbre.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF2E7D32),
                  size: 100,
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Título
          Text(
            'Crear cuenta',
            style: GoogleFonts.montserratAlternates(
              fontSize: 32,
              fontWeight: FontWeight.w600,

              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          // Campo Nombre completo
          CustomTextFormField(
            hint: 'Nombre',
            keyboardType: TextInputType.name,
            onChanged: ref.read(registerFormProvider.notifier).onNombreChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.nombre.errorMessage
                : null,
          ),

          const SizedBox(height: 12),

          CustomTextFormField(
            hint: 'Apellido',
            keyboardType: TextInputType.name,
            onChanged: ref
                .read(registerFormProvider.notifier)
                .onApellidoChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.apellido.errorMessage
                : null,
          ),

          const SizedBox(height: 12),

          // Campo Correo
          CustomTextFormField(
            hint: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.email.errorMessage
                : null,
          ),

          const SizedBox(height: 12),

          // Campo Contraseña
          CustomTextFormField(
            hint: 'Contraseña',
            obscureText: true,
            onChanged: ref
                .read(registerFormProvider.notifier)
                .onPasswordChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
          ),

          const SizedBox(height: 12),

          // Campo Confirmar contraseña
          CustomTextFormField(
            hint: 'Confirmar contraseña',
            obscureText: true,
            onChanged: ref
                .read(registerFormProvider.notifier)
                .onConfirmPasswordChanged,
            onFieldSubmitted: (_) =>
                ref.read(registerFormProvider.notifier).onFormSubmitted(),
            errorMessage: registerForm.isFormPosted
                ? (registerForm.confirmPassword.errorMessage ??
                      (registerForm.password.value !=
                              registerForm.confirmPassword.value
                          ? 'Las contraseñas no coinciden'
                          : null))
                : null,
          ),

          const SizedBox(height: 24),

          // Botón Registrarse
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: registerForm.isPosting
                  ? null
                  : ref.read(registerFormProvider.notifier).onFormSubmitted,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF114321),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFF114321,
                ).withOpacity(0.7),
                disabledForegroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: registerForm.isPosting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white70,
                      ),
                    )
                  : Text(
                      'Registrarse',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 28),

          // Divisor "O regístrate con"
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.white24)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'O regístrate con',
                  style: GoogleFonts.montserratAlternates(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Container(height: 1, color: Colors.white24)),
            ],
          ),

          const SizedBox(height: 20),

          // Botones sociales
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(28, 28),
                      painter: _GoogleLogoPainter(),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // Facebook
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1877F2),
                  ),
                  child: Center(
                    child: Text(
                      'f',
                      style: GoogleFonts.roboto(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Link a login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Ya tienes cuenta?  ',
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/login');
                  }
                },
                child: Text(
                  'Inicia sesión',
                  style: GoogleFonts.montserratAlternates(
                    color: const Color(0xFF4CAF50),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

// Logo de Google
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double strokeWidth = w * 0.18;

    const blue = Color(0xFF4285F4);
    const red = Color(0xFFEA4335);
    const yellow = Color(0xFFFBBC05);
    const green = Color(0xFF34A853);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      w - strokeWidth,
      h - strokeWidth,
    );

    paint.color = blue;
    canvas.drawArc(rect, -0.4, 1.2, false, paint);

    paint.color = green;
    canvas.drawArc(rect, 0.8, 0.9, false, paint);

    paint.color = yellow;
    canvas.drawArc(rect, 1.7, 0.8, false, paint);

    paint.color = red;
    canvas.drawArc(rect, 2.5, 0.9, false, paint);

    final linePaint = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.42, w * 0.45, strokeWidth),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
