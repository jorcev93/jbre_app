import 'package:go_router/go_router.dart';
import 'package:jbre_app/features/auth/auth.dart';
import 'package:jbre_app/features/plants/presentation/screens/plants_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ///* Auth Routes
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Planta
    GoRoute(path: '/pants', builder: (context, state) => const PlantsScreen()),
  ],

  ///! TODO: Bloquear si no se está autenticado de alguna manera
);
