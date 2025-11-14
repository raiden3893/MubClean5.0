// lib/src/features/home/home_page.dart
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // ✨ BORRADO: Esta línea causaba el conflicto
import 'package:mubclean/main.dart'; // Importa 'main.dart' para la variable global 'supabase'
import 'package:mubclean/src/features/home/widgets/home_widgets.dart';
import 'package:mubclean/src/features/home/profile_tab.dart';

// --- IMPORTS COMBINADOS (Tus cambios + los de tu compañero) ---
import 'package:flutter/services.dart'
    show rootBundle; // Importa 'rootBundle' para cargar assets
import 'dart:typed_data';
import 'dart:ui' as ui; // Para el asset de imagen (Tuyo)
import 'package:mubclean/src/features/quotation/screens/furniture_select_screen.dart'; // (Tuyo)
import 'package:mubclean/src/features/history/history_page.dart'; // (De tu compañero)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 0: Inicio, 1: Historial, 2: Perfil
  String _userName = 'Usuario';
  
  // ✨ TU CAMBIO (Logo)
  ui.Image? _logoImage; // Variable para cargar el logo

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadLogoAsset(); // ✨ TU CAMBIO (Cargar el logo al iniciar)
  }

  // Cargar el nombre del usuario desde Supabase
  Future<void> _loadUserName() async {
    try {
      // Ahora 'supabase' se refiere sin ambigüedad al de 'main.dart'
      final userId = supabase.auth.currentUser?.id; 
      if (userId != null) {
        final data = await supabase
            .from('profiles')
            .select('full_name')
            .eq('id', userId)
            .single();

        if (mounted) {
          setState(() {
            String fullName = data['full_name'] ?? 'Usuario';
            _userName = fullName.split(' ')[0];
          });
        }
      }
    } catch (e) {
      // Si falla, se queda como 'Usuario'
    }
  }

  // ✨ TU CAMBIO (Función para cargar el logo)
  Future<void> _loadLogoAsset() async {
    // Asegúrate que la ruta 'assets/mubclean_logo.png' exista en tu pubspec.yaml
    try {
      final ByteData data = await rootBundle.load('assets/mubclean_logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _logoImage = frameInfo.image;
        });
      }
    } catch (e, st) {
      debugPrint("Error al cargar el logo: $e\n$st");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el código de tu compañero para el AppBar (es más limpio)
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      
      // Lógica de tu compañero (buena idea):
      // Solo mostramos el AppBar si estamos en la pestaña 0 (Inicio)
      appBar: _selectedIndex == 0 ? AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hola,', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(_userName, style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87, size: 28),
          ),
          const SizedBox(width: 10),
        ],
      ) 
      // Si no es la pestaña 0, creamos un AppBar diferente
      : AppBar(
          title: Text(_getAppBarTitle()),
          centerTitle: true,
          elevation: 1,
      ),

      body: _getSelectedView(),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0A7AFF),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    // Esta función solo se usa si _selectedIndex != 0
    switch (_selectedIndex) {
      case 1: return 'Historial de Servicios';
      case 2: return 'Mi Perfil';
      default: return '';
    }
  }

  // --- VISTA COMBINADA ---
  Widget _getSelectedView() {
    switch (_selectedIndex) {
      case 0:
        // ✨ TU CAMBIO: Pasamos el logo a HomeContent
        return HomeContent(logoImage: _logoImage); 
      case 1:
        // ✨ CAMBIO DE TU COMPAÑERO: Mostramos la pág. de Historial
        // Si esta línea da error, ¡revisa el import de la línea 15!
        return const HistoryPage();
      case 2:
        return const ProfileTab();
      default:
        // ✨ TU CAMBIO: Pasamos el logo a HomeContent
        return HomeContent(logoImage: _logoImage);
    }
  }
}

// --- CONTENIDO DEL HOME (COMBINADO Y LIMPIADO) ---
class HomeContent extends StatelessWidget {
  // ✨ TU CAMBIO: Aceptamos el logo
  final ui.Image? logoImage; 

  const HomeContent({super.key, this.logoImage});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        
        // ✨ TU CAMBIO: Mostramos el logo si existe
        if (logoImage != null)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 120, // Tamaño fijo (más simple)
              height: 120,
              child: RawImage(image: logoImage, fit: BoxFit.contain),
            ),
          )
        else
          // Fallback si el logo no ha cargado (como en el código de tu compañero)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 120,
              height: 120,
              // Asegúrate que esta ruta exista en tu pubspec.yaml
              // Tu compañero usa 'assets/image/Logo.png'
              child: Image.asset('assets/image/Logo.png', fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image, size: 100, color: Colors.grey),
              ), 
            ),
          ),
        
        const SizedBox(height: 10),
        
        // Imagen de Mueble (de tu compañero)
        Image.asset(
          'assets/image/Mueble.png', 
          height: 150,
          errorBuilder: (context, error, stackTrace) => 
            const Icon(Icons.image, size: 100, color: Colors.grey),
        ),
        
        const SizedBox(height: 15),

        const Center(
          child: Column(
            children: [
              Text(
                "¡Estamos listos para limpiar!",
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Cotiza tu servicio de limpieza en segundos.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // 3. SECCIÓN AYUDA Y SOPORTE
        const Text("Ayuda y Soporte", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        
        const QuickAccessItem(icon: Icons.support_agent_rounded, title: "Contactar Soporte"),
        const QuickAccessItem(icon: Icons.info_outline, title: "Preguntas Frecuentes"),
        
        const SizedBox(height: 40),

        // 4. BOTÓN "COTIZAR UN SERVICIO"
        // ✨ TU CAMBIO: Botón que NAVEGA (limpié el código duplicado)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navegamos a tu pantalla
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FurnitureSelectScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A7AFF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Cotizar un Servicio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Aseguramos que el texto sea blanco
              ),
            ),
          ), 
        ), 
        
        const SizedBox(height: 20),
      ],
    );
  }
}