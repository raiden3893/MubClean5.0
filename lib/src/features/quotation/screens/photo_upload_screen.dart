// lib/src/features/quotation/screens/photo_upload_screen.dart

import 'dart:io'; // Para manejar el tipo File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // El paquete que añadimos
import '../models/quotation_model.dart';
import 'dart:developer' as developer;

class PhotoUploadScreen extends StatefulWidget {
  final Quotation quotation;

  const PhotoUploadScreen({super.key, required this.quotation});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = []; // Lista para guardar las fotos seleccionadas
  final TextEditingController _notesController = TextEditingController();

  // Función para seleccionar imágenes de la galería
  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles);
    });
  }

  // Función para tomar una foto con la cámara
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  // Función para quitar una imagen
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Función para "Enviar Fotos"
  void _submitPhotos() {
    // TODO: Lógica para subir las fotos (a Supabase Storage, por ejemplo)
    // y guardar las notas.
    developer.log('Subiendo ${_images.length} fotos...');
    developer.log('Notas adicionales: ${_notesController.text}');

    // Al terminar, volvemos al inicio
    Navigator.popUntil(context, (route) => route.isFirst);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Gracias! Tus fotos se han enviado.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Añadir Fotos (Opcional)'),
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
                'Añadir Fotos para Verificación',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sube fotos de tus muebles para ayudar al equipo a prepararse. Esto es opcional.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // --- Botones para añadir fotos ---
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galería'),
                      onPressed: _pickImages,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Cámara'),
                      onPressed: _takePhoto,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Cuadrícula de fotos seleccionadas ---
              if (_images.isNotEmpty)
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _images.length,
                  shrinkWrap: true, // Importante dentro de un ListView
                  physics: const NeverScrollableScrollPhysics(), // Importante
                  itemBuilder: (context, index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // La imagen
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_images[index].path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        // Botón para borrar
                        Positioned(
                          top: -10,
                          right: -10,
                          child: InkWell(
                            onTap: () => _removeImage(index),
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 24),

              // --- Campo de Notas ---
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Descripciones adicionales (opcional)',
                  hintText: 'Ej: El sofá tiene una mancha de vino...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
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
          onPressed: _submitPhotos,
          child: const Text('Enviar Fotos'),
        ),
      ),
    );
  }
}
