import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbre_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:jbre_app/features/auth/presentation/providers/login_form_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0E1711),
        body: const SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: _LoginForm(),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    final size = MediaQuery.of(context).size;
    
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),

          // ── Logo ──
          SizedBox(
            width: 160,
            height: 160,
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

          const SizedBox(height: 28),

          // ── Título ──
          Text(
            'Inicio de sesión',
            style: GoogleFonts.montserratAlternates(
              fontSize: 32,
              fontWeight: FontWeight.w600,

              color: Colors.white,
            ),
          ),

          const SizedBox(height: 36),

          // ── Campo Usuario ──
          _LoginTextField(
            hintText: 'Usuario',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
            errorMessage: loginForm.isFormPosted
                ? loginForm.email.errorMessage
                : null,
          ),

          const SizedBox(height: 20),

          // ── Campo Contraseña ──
          _LoginTextField(
            hintText: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            errorMessage: loginForm.isFormPosted
                ? loginForm.password.errorMessage
                : null,
          ),

          const SizedBox(height: 30),

          // ── Botón Ingresar ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: loginForm.isPosting
                  ? null
                  : ref.read(loginFormProvider.notifier).onFormSubmitted,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF114321),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Ingresar',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ── "O iniciar con" con líneas a los lados ──
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.white24)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'O iniciar con',
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

          // ── Botones sociales ──
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

          const SizedBox(height: 28),

          // ── Links inferiores ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿No tienes cuenta?  ',
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/register'),
                child: Text(
                  'Regístrate.',
                  style: GoogleFonts.montserratAlternates(
                    color: const Color(0xFF4CAF50),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '¿Olvidaste tu contrseña?',
            style: GoogleFonts.montserratAlternates(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

// ── Campo de texto estilo login ──
class _LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? errorMessage;

  const _LoginTextField({
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null;

    const errorColor = Color.fromARGB(255, 163, 157, 157);

    final normalBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? errorColor : const Color(0xFF3A7D3E),
        width: hasError ? 1.8 : 1.2,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? errorColor : const Color(0xFF4CAF50),
        width: 1.8,
      ),
    );

    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.montserratAlternates(
        fontSize: 16,
        color: Colors.white,
      ),
      cursorColor: const Color(0xFF4CAF50),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.montserratAlternates(
          color: Colors.white38,
          fontSize: 16,
        ),
        enabledBorder: normalBorder,
        focusedBorder: focusedBorder,
        errorBorder: normalBorder,
        focusedErrorBorder: focusedBorder,
        filled: true,
        fillColor: const Color(0xFF0F250F),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        errorText: errorMessage,
        errorStyle: GoogleFonts.montserratAlternates(
          color: errorColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ── Logo de Google con colores característicos ──
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double strokeWidth = w * 0.18;

    // Colores de Google
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

    // Azul (derecha arriba)
    paint.color = blue;
    canvas.drawArc(rect, -0.4, 1.2, false, paint);

    // Verde (derecha abajo)
    paint.color = green;
    canvas.drawArc(rect, 0.8, 0.9, false, paint);

    // Amarillo (abajo izquierda)
    paint.color = yellow;
    canvas.drawArc(rect, 1.7, 0.8, false, paint);

    // Rojo (arriba izquierda)
    paint.color = red;
    canvas.drawArc(rect, 2.5, 0.9, false, paint);

    // Línea horizontal azul
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
