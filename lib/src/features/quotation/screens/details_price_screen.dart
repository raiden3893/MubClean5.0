// lib/src/features/quotation/screens/details_price_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/quotation_model.dart';
import 'summary_payment_screen.dart';

class DetailsPriceScreen extends StatefulWidget {
  final Quotation quotation;
  const DetailsPriceScreen({super.key, required this.quotation});
  @override
  State<DetailsPriceScreen> createState() => _DetailsPriceScreenState();
}

class _DetailsPriceScreenState extends State<DetailsPriceScreen> {
  // --- Precios (Lógica de negocio) ---
  static const Map<FurnitureType, double> _priceList = {
    FurnitureType.sofa: 550.0,
    FurnitureType.silla: 90.0,
    FurnitureType.alfombra: 300.0,
    FurnitureType.otros: 150.0,
  };
  static const double _minimumCharge = 400.0;
  late double _totalPrice;

  // --- Estado de selección de Fecha y Hora ---
  DateTime? _selectedDay;
  String? _selectedTimeSlot;
  DateTime _focusedDay = DateTime.now();
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double calculatedPrice = 0.0;
    for (var type in widget.quotation.selectedFurniture) {
      calculatedPrice += _priceList[type] ?? 0.0;
    }
    if (calculatedPrice < _minimumCharge && calculatedPrice > 0) {
      _totalPrice = _minimumCharge;
    } else {
      _totalPrice = calculatedPrice;
    }
  }

  // --- Callbacks de Selección ---
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedTimeSlot = null;
    });
  }

  void _onTimeSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  // Navegación
  void _goToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPaymentScreen(
          quotation: widget.quotation,
          totalPrice: _totalPrice,
          selectedDate: DateTime(
            _selectedDay!.year,
            _selectedDay!.month,
            _selectedDay!.day,
            int.parse(_selectedTimeSlot!.split(':')[0]),
            int.parse(_selectedTimeSlot!.split(':')[1].split(' ')[0]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSelectionComplete =
        _selectedDay != null && _selectedTimeSlot != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Detalles y Agenda'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // --- SECCIÓN DE PRECIO ---
                Text(
                  'Resumen de Precios',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // ✨ --- INICIO DE LA CORRECCIÓN (Layout Vertical) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity, // Ocupa todo el ancho
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    // <-- 1. CAMBIO DE Row A Column
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinea a la izquierda
                    children: [
                      // 1. Título
                      const Text(
                        'Precio Base (Estimado)',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 8), // Espacio vertical
                      // 2. Precio (Debajo)
                      // ✨ 2. AQUÍ SE ARREGLA EL ERROR DEL TEXTO AZUL
                      Text(
                        // Se quita el '\' para que la variable funcione
                        '\$${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28, // Más grande para destacar
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A7AFF),
                        ),
                      ),
                    ],
                  ),
                ),
                // ✨ --- FIN DE LA CORRECCIÓN ---

                // --- TEXTO DE AYUDA (Centrado) ---
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'El precio final puede variar ligeramente según la evaluación de las fotos que subas.',
                    textAlign: TextAlign.center, // Centrado
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- SECCIÓN DE AGENDA (CALENDARIO) ---
                Text(
                  '1. Selecciona el Día',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: TableCalendar(
                    locale: 'es_ES',
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 90)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: _onDaySelected,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: const Color(0xFF0A7AFF),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- SECCIÓN: BLOQUES DE HORA ---
                Text(
                  '2. Selecciona la Hora',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTimeSlots(),

                // --- BLOQUE DE RESUMEN EN TIEMPO REAL ---
                const SizedBox(height: 30),
                _buildSummaryBlock(),
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
              onPressed: isSelectionComplete ? _goToSummary : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelectionComplete
                    ? theme.colorScheme.primary
                    : Colors.grey.shade300,
              ),
              child: const Text('Confirmar Agendamiento'),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER PARA LOS BLOQUES DE HORA ---
  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _timeSlots.map((time) {
        final isSelected = _selectedTimeSlot == time;
        return ChoiceChip(
          label: Text(time),
          selected: isSelected,
          onSelected: (selected) => _onTimeSelected(time),
          selectedColor: const Color(0xFF0A7AFF),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF0A7AFF)
                  : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      }).toList(),
    );
  }

  // --- WIDGET HELPER PARA EL RESUMEN ---
  Widget _buildSummaryBlock() {
    if (_selectedDay != null && _selectedTimeSlot != null) {
      final String formattedDate = DateFormat.yMMMMEEEEd(
        'es_ES',
      ).format(_selectedDay!);
      final String summaryText = 'Cita: $formattedDate | $_selectedTimeSlot';

      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Text(
          summaryText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
