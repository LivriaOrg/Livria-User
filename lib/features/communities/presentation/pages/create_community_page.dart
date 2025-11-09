import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_colors.dart';
import 'dart:io';
import '../../domain/entities/community.dart';
import '../../domain/usecases/create_community_usecase.dart';

enum CommunityType {
  literature(1, 'LITERATURE'),
  nonFiction(2, 'NON-FICTION'),
  fiction(3, 'FICTION'),
  mangasComics(4, 'MANGAS & COMICS'),
  juvenile(5, 'JUVENILE'),
  children(6, 'CHILDREN'),
  ebooksAudiobooks(7, 'EBOOKS & AUDIOBOOKS'),
  general(8, 'GENERAL');

  final int id;
  final String label;
  const CommunityType(this.id, this.label);
}

class CreateCommunityPage extends StatefulWidget {
  final CreateCommunityUseCase createCommunityUseCase;

  const CreateCommunityPage({
    Key? key,
    required this.createCommunityUseCase,
  }) : super(key: key);

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController(); // URL del icono
  final TextEditingController _bannerController = TextEditingController(); // URL del banner

  CommunityType? _selectedType = CommunityType.literature; // Valor inicial

  // Estado para los archivos de imagen seleccionados (simulados)
  File? _selectedIconFile;
  File? _selectedBannerFile;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message, {required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- LÓGICA DE SIMULACIÓN DE IMAGE PICKER ---

  void _pickImage(bool isIcon, ImageSource source) async {
    // Simulamos la lógica de `image_picker.pickImage(source: source)`.

    // Si se selecciona una imagen, limpiamos el campo de URL
    if (source == ImageSource.gallery) {
      if (isIcon) {
        setState(() {
          _selectedIconFile = File('simulated_icon_path/temp.jpg');
          _imageController.clear();
        });
        _showSnackbar('Ícono seleccionado de la galería.', color: AppColors.softTeal);
      } else {
        setState(() {
          _selectedBannerFile = File('simulated_banner_path/temp.jpg');
          _bannerController.clear();
        });
        _showSnackbar('Banner seleccionado de la galería.', color: AppColors.softTeal);
      }
    } else if (source == ImageSource.camera) {
      if (isIcon) {
        setState(() {
          _selectedIconFile = File('simulated_icon_path/camera_temp.jpg');
          _imageController.clear();
        });
        _showSnackbar('Ícono capturado con la cámara.', color: AppColors.softTeal);
      } else {
        setState(() {
          _selectedBannerFile = File('simulated_banner_path/camera_temp.jpg');
          _bannerController.clear();
        });
        _showSnackbar('Banner capturado con la cámara.', color: AppColors.softTeal);
      }
    }
  }

  Future<String> _uploadFileAndGetUrl(File file, String name) async {
    // Simulación de una subida de 1 segundo
    await Future.delayed(const Duration(seconds: 1));
    return 'https://cdn.livria.com/uploaded/community/${name}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  // --- LÓGICA DE CREACIÓN ---
  Future<void> _handleCreateCommunity() async {
    // 1. Validar el formulario.
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    if (_selectedType == null) {
      _showSnackbar('Debe seleccionar un tipo de comunidad.', color: AppColors.secondaryYellow);
      return;
    }

    // 2. Comprobar que se ha proporcionado **alguna** imagen/URL para ícono y banner.
    if (_imageController.text.isEmpty && _selectedIconFile == null) {
      _showSnackbar('Debe proporcionar una URL o seleccionar una imagen para el Ícono.', color: AppColors.errorRed);
      return;
    }
    if (_bannerController.text.isEmpty && _selectedBannerFile == null) {
      _showSnackbar('Debe proporcionar una URL o seleccionar una imagen para el Banner.', color: AppColors.errorRed);
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    String finalImageUrl = _imageController.text.trim();
    String finalBannerUrl = _bannerController.text.trim();

    try {
      // 3. Subir el ícono si se seleccionó un archivo local
      if (_selectedIconFile != null) {
        finalImageUrl = await _uploadFileAndGetUrl(_selectedIconFile!, 'icon');
      }

      // 4. Subir el banner si se seleccionó un archivo local
      if (_selectedBannerFile != null) {
        finalBannerUrl = await _uploadFileAndGetUrl(_selectedBannerFile!, 'banner');
      }

      // 5. Crear la comunidad usando las URLs finales
      final Community newCommunity = await widget.createCommunityUseCase.call(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType!.id,
        image: finalImageUrl,
        banner: finalBannerUrl,
      );

      _showSnackbar(
        'Comunidad "${newCommunity.name}" creada exitosamente con ID ${newCommunity.id}!',
        color: AppColors.vibrantBlue,
      );

      // Limpiar y salir
      _nameController.clear();
      _descriptionController.clear();
      _imageController.clear();
      _bannerController.clear();
      if (mounted) {
        setState(() {
          _selectedType = CommunityType.literature;
          _selectedIconFile = null;
          _selectedBannerFile = null;
        });
        Navigator.of(context).pop(true); // Indica éxito y fuerza recarga en la pantalla anterior
      }
    } catch (e) {
      print('Error al crear comunidad: $e');
      _showSnackbar(
        'Fallo al crear comunidad: ${e.toString().replaceFirst('Exception: ', '')}',
        color: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // -------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Create New Community',
          style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Nombre de la Comunidad
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Community Name',
                hintText: 'e.g., The Fantasy Readers Club',
                maxLength: 50,
              ),
              const SizedBox(height: 16),

              // Descripción
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Describe what this community is about',
                maxLines: 4,
                maxLength: 250,
              ),
              const SizedBox(height: 16),

              // Tipo de Comunidad (Dropdown)
              _buildTypeDropdown(),
              const SizedBox(height: 24),

              // Widget para Ícono de Comunidad
              _buildImageInput(
                context,
                title: 'Community Icon',
                hintText: 'https://image.url/icon.png',
                controller: _imageController,
                file: _selectedIconFile,
                onGallery: () => _pickImage(true, ImageSource.gallery),
                onCamera: () => _pickImage(true, ImageSource.camera),
                onRemove: () => setState(() { _selectedIconFile = null; }),
              ),
              const SizedBox(height: 16),

              // Widget para Banner de Comunidad
              _buildImageInput(
                context,
                title: 'Community Banner',
                hintText: 'https://image.url/banner.jpg',
                controller: _bannerController,
                file: _selectedBannerFile,
                onGallery: () => _pickImage(false, ImageSource.gallery),
                onCamera: () => _pickImage(false, ImageSource.camera),
                onRemove: () => setState(() { _selectedBannerFile = null; }),
              ),
              const SizedBox(height: 32),

              // Botón de Creación
              ElevatedButton(
                onPressed: _isLoading ? null : _handleCreateCommunity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 3,
                  ),
                )
                    : Text(
                  'CREATE COMMUNITY',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildImageInput(
      BuildContext context, {
        required String title,
        required String hintText,
        required TextEditingController controller,
        required File? file,
        required VoidCallback onGallery,
        required VoidCallback onCamera,
        required VoidCallback onRemove, // Nuevo parámetro para el botón de cerrar
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del campo
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Campo de texto para URL
        TextFormField(
          controller: controller,
          enabled: file == null, // Deshabilitar si ya se seleccionó un archivo
          validator: (value) {
            // Si el campo tiene valor (y no hay archivo local), debe ser una URL válida
            if (file == null && value != null && value.isNotEmpty) {
              return _urlValidator(value);
            }
            // Si no hay archivo ni URL, el control de "Requerido" se hace en _handleCreateCommunity
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Paste Image URL',
            hintText: hintText,
            labelStyle: TextStyle(color: file == null ? AppColors.darkBlue : AppColors.softTeal),
            prefixIcon: const Icon(Icons.link, color: AppColors.softTeal),
            // Botón de eliminar archivo local
            suffixIcon: file != null
                ? IconButton(
              icon: const Icon(Icons.close, color: AppColors.errorRed),
              onPressed: onRemove, // Usa el callback
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.softTeal),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.softTeal.withOpacity(0.5), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
            fillColor: file == null ? AppColors.lightGrey : AppColors.lightGrey.withOpacity(0.5),
            filled: true,
          ),
        ),

        // Indicador de imagen seleccionada
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Image Selected: ${file.path.split('/').last}',
              style: const TextStyle(color: AppColors.vibrantBlue, fontStyle: FontStyle.italic),
            ),
          ),

        const SizedBox(height: 12),
        const Text('OR Select from device:', style: TextStyle(color: AppColors.darkBlue)),
        const SizedBox(height: 8),

        // Botones de selección de archivo
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                // Deshabilitado si hay archivo local o URL pegada
                onPressed: file != null || controller.text.isNotEmpty ? null : onGallery,
                icon: const Icon(Icons.photo_library, color: AppColors.primaryOrange),
                label: const Text('Gallery'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryOrange,
                  side: const BorderSide(color: AppColors.primaryOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                // Deshabilitado si hay archivo local o URL pegada
                onPressed: file != null || controller.text.isNotEmpty ? null : onCamera,
                icon: const Icon(Icons.camera_alt, color: AppColors.primaryOrange),
                label: const Text('Camera'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryOrange,
                  side: const BorderSide(color: AppColors.primaryOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.darkBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.softTeal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.softTeal.withOpacity(0.5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
        ),
        fillColor: AppColors.lightGrey,
        filled: true,
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.softTeal.withOpacity(0.5), width: 1.5),
      ),
      child: DropdownButtonFormField<CommunityType>(
        decoration: const InputDecoration(
          labelText: 'Community Type',
          labelStyle: TextStyle(color: AppColors.darkBlue),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        value: _selectedType,
        items: CommunityType.values.map((CommunityType type) {
          return DropdownMenuItem<CommunityType>(
            value: type,
            child: Text(type.label, style: const TextStyle(color: AppColors.darkBlue)),
          );
        }).toList(),
        onChanged: (CommunityType? newValue) {
          setState(() {
            _selectedType = newValue;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a community type.';
          }
          return null;
        },
        dropdownColor: AppColors.white,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryOrange),
      ),
    );
  }

  String? _urlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);

    if (uri == null || !uri.isAbsolute) {
      return 'Please enter a valid absolute URL (e.g., must start with http:// or https://).';
    }
    return null;
  }
}

enum ImageSource { gallery, camera }