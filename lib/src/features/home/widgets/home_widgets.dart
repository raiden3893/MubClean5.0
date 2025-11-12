import 'package:flutter/material.dart';

// 1. BOTÓN GRANDE AZUL
class SolicitarServicioButton extends StatelessWidget {
  const SolicitarServicioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
        label: const Text(
          'Solicitar un Servicio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A7AFF), // Azul Mublean
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

// 2. TARJETA DE PRÓXIMA CITA
class ProximaCitaCard extends StatelessWidget {
  const ProximaCitaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zona de la imagen (Gris segura)
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFCFD8DC), // Gris azulado
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.weekend, size: 50, color: Colors.white),
                  SizedBox(height: 5),
                  Text("Limpieza de Sala", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRÓXIMA CITA', style: TextStyle(color: Color(0xFF0A7AFF), fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 5),
                const Text('Limpieza de Sofá', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                Text('Martes, 28 de Octubre\n10:00 AM', style: TextStyle(color: Colors.grey[700], fontSize: 15, height: 1.4)),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A7AFF), 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: const Text('Ver Detalles'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. TARJETA DE COTIZACIÓN
class CotizacionCard extends StatelessWidget {
  const CotizacionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.3)), // Borde naranja sutil
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA000)),
              SizedBox(width: 8),
              Text('COTIZACIÓN PENDIENTE', style: TextStyle(color: Color(0xFFFFA000), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Lavado de Alfombras', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 5),
          const Text('#MC-12045', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA000),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              child: const Text('Revisar y Aprobar'),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. BOTÓN DE ACCESO RÁPIDO (GENÉRICO)
class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const QuickAccessItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0A7AFF), size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}