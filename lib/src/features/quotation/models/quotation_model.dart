// lib/src/features/quotation/models/quotation_model.dart

// Un enum para saber qué tipo de mueble es
enum FurnitureType { sofa, silla, alfombra, otros }

// Una clase simple para guardar la cotización mientras el usuario avanza
class Quotation {
  // Usamos un Set para que no se puedan repetir
  final Set<FurnitureType> selectedFurniture;

  // Más campos que añadiremos en el futuro:
  // DateTime? selectedDate;
  // List<File>? photos;
  // double? finalPrice;

  Quotation({required this.selectedFurniture});

  // Constructor inicial vacío
  factory Quotation.empty() {
    return Quotation(selectedFurniture: <FurnitureType>{});
  }

  // Método para "copiar" y modificar el objeto
  Quotation copyWith({Set<FurnitureType>? selectedFurniture}) {
    return Quotation(
      selectedFurniture: selectedFurniture ?? this.selectedFurniture,
    );
  }
}
