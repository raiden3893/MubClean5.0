import 'package:mubclean/src/features/quotation/screens/details_price_screen.dart';
import 'package:flutter/material.dart';
// ✨ 1. Importamos el modelo de cotización (SOLO UNA VEZ)
import '../models/quotation_model.dart';

class FurnitureSelectScreen extends StatefulWidget {
  const FurnitureSelectScreen({super.key});

  @override
  State<FurnitureSelectScreen> createState() => _FurnitureSelectScreenState();
}

class _FurnitureSelectScreenState extends State<FurnitureSelectScreen> {
  // Empezamos con un set vacío de los muebles seleccionados
  final Set<FurnitureType> _selection = <FurnitureType>{};

  // Función para manejar el clic en un item
  void _toggleSelection(FurnitureType type) {
    setState(() {
      if (_selection.contains(type)) {
        _selection.remove(type);
      } else {
        _selection.add(type);
      }
    });
  }

  // Función para el botón "Siguiente"
  void _goToNextStep() {
    if (_selection.isEmpty) {
      // Mostrar un error si no ha seleccionado nada
      // ✨ 2. Arreglamos los errores de 'Undefined name'
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos un tipo de mueble.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // (Código nuevo en _goToNextStep)

    // Creamos el objeto de cotización con la selección
    final quotation = Quotation(selectedFurniture: _selection);

    // Navegamos al Paso 2 (Detalles y Agenda) y le pasamos la cotización
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPriceScreen(quotation: quotation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✨ 3. Arreglamos los errores de 'Undefined class'
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cotizar Servicio'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selección de Mueble',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '¿Qué tipo de mueble te gustaría limpiar?',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // -- OPCIONES DE MUEBLES --
              _buildSelectableItem(
                context: context,
                title: 'Sofá',
                icon: Icons.chair_rounded, // Reemplazar con tu ícono
                type: FurnitureType.sofa,
              ),
              const SizedBox(height: 15),
              _buildSelectableItem(
                context: context,
                title: 'Silla',
                icon: Icons.chair_alt_rounded, // Reemplazar con tu ícono
                type: FurnitureType.silla,
              ),
              const SizedBox(height: 15),
              _buildSelectableItem(
                context: context,
                title: 'Alfombra',
                icon: Icons.square_foot_rounded, // Reemplazar con tu ícono
                type: FurnitureType.alfombra,
              ),
              const SizedBox(height: 15),
              _buildSelectableItem(
                context: context,
                title: 'Otros',
                icon: Icons.more_horiz_rounded, // Reemplazar con tu ícono
                type: FurnitureType.otros,
              ),
            ],
          ),
        ),
      ),

      // --- BOTÓN DE NAVEGACIÓN ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF2F2F7))),
        ),
        child: ElevatedButton(
          onPressed: _goToNextStep,
          child: const Text('Siguiente'),
        ),
      ),
    );
  }

  // Widget helper para crear los botones seleccionables
  Widget _buildSelectableItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required FurnitureType type,
  }) {
    final bool isSelected = _selection.contains(type);
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _toggleSelection(type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha((255 * 0.1).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? colorScheme.primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black87 : Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            Checkbox(
              value: isSelected,
              onChanged: (val) => _toggleSelection(type),
              activeColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
