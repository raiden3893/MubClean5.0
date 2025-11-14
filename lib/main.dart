import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mubclean/src/features/auth/login_page.dart';
import 'package:mubclean/src/features/home/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos la localización para español
  await initializeDateFormatting('es_ES', null);

  await Supabase.initialize(
    url: 'https://nvswszwballqzzuziwyx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im52c3dzendiYWxscXp6dXppd3l4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5MTIyNTUsImV4cCI6MjA3ODQ4ODI1NX0.OxfXYVGveWAlMxsSVB4MBIA-3TT_mKuXrCfOWkQs0AY',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores extraídos de tu imagen de referencia
    const Color mubBlue = Color(0xFF0A7AFF);
    const Color mubText = Color(0xFF1D1D1F);
    const Color mubInputBg = Color(0xFFF2F2F7);

    return MaterialApp(
      title: 'MubClean',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: mubBlue, primary: mubBlue),

        // Configuración global de estilos para que se parezca a tu imagen
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: mubText),
          titleTextStyle: TextStyle(
            color: mubText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: mubInputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mubBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // Lógica de sesión: Si ya está logueado -> Home, si no -> Login
      home: supabase.auth.currentSession != null
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
