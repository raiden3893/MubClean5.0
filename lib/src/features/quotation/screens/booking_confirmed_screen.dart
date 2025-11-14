// lib/src/features/quotation/screens/booking_confirmed_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/quotation_model.dart';
import 'package:mubclean/src/features/quotation/screens/photo_upload_screen.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final Quotation quotation;
  final double totalPrice;
  final DateTime selectedDate;

  const BookingConfirmedScreen({
    super.key,
    required this.quotation,
    required this.totalPrice,
    required this.selectedDate,
  });

  void _goToPhotoUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoUploadScreen(quotation: quotation),
      ),
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String formattedDate =
        DateFormat.yMMMMEEEEd('es_ES').format(selectedDate);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('¡Reserva Confirmada!'),
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      // --- CORRECCIÓN VERTICAL: AÑADIDO SingleChildScrollView ---
      body: SingleChildScrollView(
        // --- CORRECCIÓN ESTÉTICA: Padding horizontal ---
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: Colors.green, size: 80),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Tu reserva está confirmada!',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Hemos recibido tu pago y agendado tu servicio.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              // Padding interno para que el contenido no se pegue
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    icon: Icons.calendar_today,
                    title: 'Fecha del Servicio:',
                    value: formattedDate,
                    softWrapValue: true, // Fecha puede bajar de línea
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    icon: Icons.receipt_long,
                    title: 'Total Pagado:',
                    value: '\$${totalPrice.toStringAsFixed(2)}',
                    softWrapValue: false, // Precio no debe bajar de línea
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, // Asegura que el botón ocupe el ancho completo
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _goToPhotoUpload(context),
                child: const Text('Subir Fotos Ahora (Recomendado)'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _goToHome(context),
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER CORREGIDO ---
  Widget _buildSummaryRow({
    required IconData icon,
    required String title,
    required String value,
    bool softWrapValue = false, // Nuevo parámetro
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Flexible( // Wrap title in Flexible
          child: Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
            softWrap: true, // Ensure title wraps if long
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: softWrapValue,
            overflow: softWrapValue ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
  // --- FIN DE LA CORRECCIÓN ---
}