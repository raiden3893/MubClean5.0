// lib/src/features/quotation/screens/summary_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mubclean/src/features/quotation/screens/booking_confirmed_screen.dart';
import '../models/quotation_model.dart';

class SummaryPaymentScreen extends StatelessWidget {
  final Quotation quotation;
  final double totalPrice;
  final DateTime selectedDate;

  const SummaryPaymentScreen({
    super.key,
    required this.quotation,
    required this.totalPrice,
    required this.selectedDate,
  });

  // Función para el botón "Pagar"
  void _processPayment(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmedScreen(
          quotation: quotation,
          totalPrice: totalPrice,
          selectedDate: selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String formattedDate = DateFormat.yMMMMEEEEd(
      'es_ES',
    ).format(selectedDate);
    final String formattedTime = DateFormat.jm('es_ES').format(selectedDate);

    // Genera el string de artículos con saltos de línea
    final String furnitureSummary = quotation.selectedFurniture.isEmpty
        ? 'Ningún mueble seleccionado'
        : quotation.selectedFurniture
              .map((type) => '• ${_getFurnitureName(type)}')
              .join('\n'); // Usa saltos de línea

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Resumen y Pago'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // --- 1. Resumen del Servicio ---
                Text(
                  'Resumen del Servicio',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // ✨ --- INICIO DE LA CORRECCIÓN DE ACOMODO ---
                // Aplicamos el layout vertical que te gustó
                _buildSummaryCard(
                  children: [
                    // Usamos un layout de 2 columnas para Fecha y Hora
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            // <-- NUEVO HELPER
                            'Fecha:',
                            formattedDate,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryItem(
                            // <-- NUEVO HELPER
                            'Hora (aprox.):',
                            formattedTime,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    // Artículos usa el layout vertical normal
                    _buildSummaryItem(
                      // <-- NUEVO HELPER
                      'Artículos a limpiar:',
                      furnitureSummary,
                    ),
                  ],
                ),

                // ✨ --- FIN DE LA CORRECCIÓN ---
                const SizedBox(height: 30),

                // --- 2. Resumen del Pago ---
                Text(
                  'Detalles del Pago',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // ✨ --- INICIO DE LA CORRECCIÓN DE ACOMODO ---
                _buildSummaryCard(
                  children: [
                    _buildSummaryItem(
                      // <-- NUEVO HELPER
                      'Precio Base:',
                      '\$${totalPrice.toStringAsFixed(2)}',
                    ),
                    _buildSummaryItem(
                      // <-- NUEVO HELPER
                      'Tarifa de Servicio:',
                      '\$0.00',
                    ),
                    _buildSummaryItem(
                      // <-- NUEVO HELPER
                      'Descuento:',
                      '-\$0.00',
                    ),
                    const Divider(height: 20, thickness: 1.5),
                    _buildSummaryItem(
                      // <-- NUEVO HELPER
                      'Total a Pagar:',
                      '\$${totalPrice.toStringAsFixed(2)}',
                      isTotal: true, // Lo hace más grande
                    ),
                  ],
                ),

                // ✨ --- FIN DE LA CORRECCIÓN ---
                const SizedBox(height: 30),

                // --- 3. Método de Pago ---
                Text(
                  'Método de Pago',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  children: [
                    // Este layout (Row + Expanded) está bien
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '**** **** **** 1234',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cambiar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- BOTÓN DE NAVEGACIÓN ---
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF2F2F7))),
            ),
            child: ElevatedButton(
              onPressed: () => _processPayment(context),
              child: const Text('Confirmar Reserva y Pagar'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets Helper y funciones para construir el resumen ---
}

// Función helper para convertir el Enum en un String legible
String _getFurnitureName(FurnitureType type) {
  switch (type) {
    case FurnitureType.sofa:
      return 'Sofá';
    case FurnitureType.silla:
      return 'Silla';
    case FurnitureType.alfombra:
      return 'Alfombra';
    case FurnitureType.otros:
      return 'Otros Muebles';
  }
}

// Widget helper para la tarjeta de resumen
Widget _buildSummaryCard({required List<Widget> children}) {
  return Container(
    padding: const EdgeInsets.all(20), // Padding interno adecuado
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

// ✨ --- NUEVO WIDGET HELPER (El que te gusta de la Imagen 1) ---
// Este reemplaza al antiguo _buildSummaryRow
Widget _buildSummaryItem(String title, String value, {bool isTotal = false}) {
  // Estilo para el título (ej. "Precio Base:")
  final titleStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[600], // Un gris suave
  );

  // Estilo para el valor (ej. "$550.00")
  final valueStyle = TextStyle(
    fontSize: isTotal ? 24 : 20, // Hacemos el total un poco más grande
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 6.0,
    ), // Espacio entre cada item
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Alinea todo a la izquierda
      children: [
        // 1. Título (arriba)
        Text(title, style: titleStyle),
        const SizedBox(height: 4), // Pequeño espacio
        // 2. Valor (abajo)
        Text(value, style: valueStyle),
      ],
    ),
  );
}
