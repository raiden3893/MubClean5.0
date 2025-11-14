import 'package:flutter/material.dart';
import 'package:mubclean/main.dart'; // Importa 'main.dart' para la variable global 'supabase'
import 'package:mubclean/src/features/home/widgets/home_widgets.dart'; // Asegúrate que esté importado
import 'package:mubclean/src/features/home/profile_tab.dart';

// --- NUEVO IMPORT para la imagen del logo ---
import 'package:flutter/services.dart'
    show rootBundle; // Importa 'rootBundle' para cargar assets
import 'dart:typed_data';
import 'dart:ui' as ui; // Para el asset de imagen

// ✨ --- 1. IMPORT DE LA NUEVA PANTALLA DE COTIZACIÓN ---
import 'package:mubclean/src/features/quotation/screens/furniture_select_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 0: Inicio, 1: Historial, 2: Perfil
  String _userName = 'Usuario';
  ui.Image? _logoImage; // Variable para cargar el logo

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadLogoAsset(); // Cargar el logo al iniciar
  }

  // Cargar el nombre del usuario
  Future<void> _loadUserName() async {
    try {
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
      // Manejar error o dejar nombre por defecto
    }
  }

  // Cargar el logo de la empresa
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
      debugPrint(
        "Error al cargar el logo: $e\n$st",
      ); // Usar debugPrint para depuración
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        toolbarHeight: screenHeight * 0.1,
        automaticallyImplyLeading: false,
        title: _selectedIndex == 0
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: screenWidth * 0.06,
                      backgroundColor: const Color(0xFF0A7AFF),
                      child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.07),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hola,',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        _userName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Text(
                _getAppBarTitle(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          // Icono de Notificaciones
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black87,
              size: 28,
            ),
          ),
          SizedBox(width: screenWidth * 0.02), // Espacio
        ],
      ),

      body: _getSelectedView(),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0A7AFF),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 1:
        return 'Historial de Servicios';
      case 2:
        return 'Mi Perfil';
      default:
        return '';
    }
  }

  Widget _getSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return HomeContent(
          logoImage: _logoImage,
        ); // Pasamos el logo al HomeContent
      case 1:
        return const Center(child: Text("Aquí verás tus servicios anteriores"));
      case 2:
        return const ProfileTab();
      default:
        return HomeContent(logoImage: _logoImage);
    }
  }
}

// --- CONTENIDO DEL HOME MEJORADO ---
class HomeContent extends StatelessWidget {
  final ui.Image? logoImage; // Recibimos el logo

  const HomeContent({super.key, this.logoImage});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      children: [
        // 1. LOGO DE LA EMPRESA (Si está cargado)
        if (logoImage != null)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: screenWidth * 0.3, // Ajusta el tamaño del logo
              height: screenWidth * 0.3,
              child: RawImage(image: logoImage, fit: BoxFit.contain),
            ),
          ),
        SizedBox(height: screenHeight * 0.01),

        // 2. IMAGEN VISTOSA CENTRAL
        // Asegúrate de tener esta imagen en 'assets/cleaning_image.png'
        Image.asset(
          'assets/cleaning_image.png',
          height: screenHeight * 0.2,
          // Manejo de error si la imagen no se encuentra
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: screenHeight * 0.2,
              color: Colors.grey[200],
              child: const Center(child: Text('Imagen no encontrada')),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.02),

        Center(
          child: Column(
            children: [
              const Text(
                "¡Estamos listos para limpiar!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              const Text(
                "Cotiza tu servicio de limpieza en segundos.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.05), // Espacio
        // 3. SECCIÓN AYUDA Y SOPORTE
        const Text(
          "Ayuda y Soporte",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenHeight * 0.02),

        const QuickAccessItem(
          icon: Icons.support_agent_rounded,
          title: "Contactar Soporte",
        ),
        const QuickAccessItem(
          icon: Icons.info_outline,
          title: "Preguntas Frecuentes",
        ),

        // ✨ --- INICIO DE LA CORRECCIÓN --- ✨
        // El código que pegaste estaba mal ubicado. Esta es la posición correcta,
        // después de los "QuickAccessItem".

        // 4. BOTÓN "COTIZAR UN SERVICIO"
        SizedBox(height: screenHeight * 0.05), // Espacio

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // ✨ --- AQUÍ ESTÁ LA NAVEGACIÓN ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FurnitureSelectScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A7AFF),
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cotizar un Servicio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Aseguramos que el texto sea blanco
              ),
            ),
          ), // Cierre del ElevatedButton
        ), // Cierre del SizedBox

        // ✨ --- FIN DE LA CORRECCIÓN --- ✨
        SizedBox(height: screenHeight * 0.025),
      ],
    );
  }
}
