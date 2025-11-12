import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mubclean/src/features/auth/login_page.dart';
// Importamos tus widgets
import 'package:mubclean/src/features/home/widgets/home_widgets.dart';
// Importamos la pestaña de perfil
import 'package:mubclean/src/features/home/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 0: Inicio, 1: Servicios, 2: Agenda, 3: Perfil

  // Función de logout (se usará si es necesario, aunque ya está en el perfil)
  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), 
      
      // --- APP BAR (CAMBIA SEGÚN LA PANTALLA) ---
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: _selectedIndex == 0 // Solo mostramos el saludo en el Inicio (índice 0)
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF0A7AFF),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido,', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text('Carlos', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              )
            : Text( // En otras pantallas mostramos el título de la sección
                _getAppBarTitle(),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
        actions: [
          if (_selectedIndex == 0) // Solo mostramos logout rápido en Inicio
            Container(
              margin: const EdgeInsets.only(right: 15),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                tooltip: "Cerrar Sesión",
              ),
            )
        ],
      ),

      // --- CUERPO (CAMBIA SEGÚN LA SELECCIÓN) ---
      body: _getSelectedView(),

      // --- BARRA INFERIOR ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0A7AFF),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.cleaning_services), label: 'Servicios'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // Lógica para decidir el título del AppBar
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 1: return 'Nuestros Servicios';
      case 2: return 'Mi Agenda';
      case 3: return 'Mi Perfil';
      default: return '';
    }
  }

  // Lógica para decidir qué pantalla mostrar
  Widget _getSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return const HomeContent(); // Hemos extraído el Home a su propio widget abajo
      case 1:
        return const Center(child: Text("Pantalla de Servicios (Próximamente)"));
      case 2:
        return const Center(child: Text("Pantalla de Agenda (Próximamente)"));
      case 3:
        return const ProfileTab(); // <--- ¡AQUÍ CONECTAMOS EL PERFIL!
      default:
        return const HomeContent();
    }
  }
}

// --- WIDGET CON EL CONTENIDO DEL HOME (Extraído para mantener orden) ---
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        SolicitarServicioButton(),
        SizedBox(height: 30),
        ProximaCitaCard(),
        SizedBox(height: 25),
        CotizacionCard(),
        SizedBox(height: 35),
        Text("Accesos Rápidos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        QuickAccessItem(icon: Icons.assignment_outlined, title: "Mis Solicitudes"),
        QuickAccessItem(icon: Icons.history_rounded, title: "Historial de Servicios"),
        QuickAccessItem(icon: Icons.support_agent_rounded, title: "Soporte Técnico"),
        SizedBox(height: 50),
      ],
    );
  }
}