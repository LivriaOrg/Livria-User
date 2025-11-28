import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../common/theme/app_colors.dart';

class SmartProfileImage extends StatelessWidget {
  final String imageData;
  final double size;

  const SmartProfileImage({
    super.key,
    required this.imageData,
    this.size = 120
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageData.isEmpty) {
      return _buildPlaceholder();
    }

    if (imageData.startsWith('http')) {
      return Image.network(
        imageData,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    if (imageData.startsWith('data:image')) {
      try {
        final base64String = imageData.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        );
      } catch (e) {
        return _buildPlaceholder();
      }
    }

    try {
      final Uint8List bytes = base64Decode(imageData);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lightGrey,
      child: Icon(Icons.person, size: size * 0.5, color: AppColors.softTeal),
    );
  }
}