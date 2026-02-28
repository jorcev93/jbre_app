import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbre_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:jbre_app/features/shared/shared.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado de autenticación para ver los roles
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isAdmin = user?.roles.contains('admin') ?? false;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0E1711),
      endDrawer: SideMenu(scaffoldKey: scaffoldKey), // Menú lateral derecho

      appBar: AppBar(
        title: Text(
          'JBRE',
          style: GoogleFonts.montserratAlternates(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1B3B22),
        elevation: 0,
        automaticallyImplyLeading: false, // Quitar flecha de regresar
        actions: const [
          SizedBox.shrink(),
        ], // Forzar que no haya ícono de EndDrawer
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: const [_InicioView(), _AsistenteView(), _GaleriaView()],
      ),

      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              label: Text(
                'Nueva planta',
                style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Navegar a la pantalla de crear nueva planta
              },
            )
          : null, // Si no es admin, no mostramos el botón

      bottomNavigationBar: _CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            // Si toca "Perfil" (índice 3), abre el menú lateral
            scaffoldKey.currentState?.openEndDrawer();
          } else {
            // Sino, cambia la vista principal
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

// -----------------------------------------------------
// Bottom Navigation Bar Personalizado
// -----------------------------------------------------
class _CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomBottomNavigation({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color(0xFF0E1711), // Fondo oscuro
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex == 3
            ? 0
            : currentIndex, // El perfil no queda como seleccionado visualmente en las tabs
        onTap: onTap,
        type: BottomNavigationBarType.fixed, // Mostrar todos los labels
        backgroundColor: const Color(0xFF0E1711),
        selectedItemColor: const Color(
          0xFF4CAF50,
        ), // Color verde cuando está activo
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: GoogleFonts.montserratAlternates(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.montserratAlternates(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Asistente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library_rounded),
            label: 'Galería',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// Vistas placeholder (Inicio, Asistente, Galería)
// -----------------------------------------------------

class _InicioView extends StatelessWidget {
  const _InicioView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Center(
            child: SizedBox(
              height: 150,
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
          ),

          const SizedBox(height: 30),

          Text(
            'Misión',
            style: GoogleFonts.montserratAlternates(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Impulsar la Investigación y Educación Ambiental para logar la conservación ex-situ de la flora nativa y endémica de la región sur del Ecuador.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.montserratAlternates(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Visión',
            style: GoogleFonts.montserratAlternates(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'El Jardín Botánico «Reinaldo Espinosa» es líder de la conservación ex-situ de la flora nativa y endémica de la región sur del Ecuador.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.montserratAlternates(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Objetivos',
            style: GoogleFonts.montserratAlternates(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Facilitar las condiciones de un laboratorio natural para complementar la formación académica de los estudiantes.\n'
            '• Desarrollar programas de Educación Ambiental, que despierten el interés colectivo por la conservación.\n'
            '• Establecer programas de Investigación Científica para el manejo y conservación de la flora nativa y endémica.\n'
            '• Impulsar la conservación ex-situ de las especies nativas y endémicas de la región Sur del Ecuador.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.montserratAlternates(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 100,
          ), // Espacio extra para que no lo tape el FAB
        ],
      ),
    );
  }
}

class _AsistenteView extends StatelessWidget {
  const _AsistenteView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_rounded,
            size: 80,
            color: Colors.green.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            '¿Cómo puedo ayudarte hoy?',
            style: GoogleFonts.montserratAlternates(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _GaleriaView extends StatelessWidget {
  const _GaleriaView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(
                0xFF142418,
              ), // Slightly lighter dark green than background
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              style: GoogleFonts.montserratAlternates(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: GoogleFonts.montserratAlternates(
                  color: Colors.white54,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
              ),
            ),
          ),
        ),

        // Grid View
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85, // Slightly taller than wide
            ),
            itemCount: 4, // Placeholder count for Planta 1 to 4
            itemBuilder: (context, index) {
              return _PlantCard(title: 'Planta ${index + 1}');
            },
          ),
        ),
      ],
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String title;

  const _PlantCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF070B08), // Darker inner background
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1B3B22), // Green border outline
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Content inside the card
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
