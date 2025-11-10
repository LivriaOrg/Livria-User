import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_colors.dart';

class MultiColorLine extends StatelessWidget {
  const MultiColorLine({super.key, this.height = 4}); // height es para el grosor

  final double height;

  @override
  Widget build(BuildContext context) {
    // usamos una fila con 7 contenedores expandidos
    return Row(
      children: [
        _buildColorBar(AppColors.primaryOrange),
        _buildColorBar(AppColors.black),
        _buildColorBar(AppColors.secondaryYellow),
        _buildColorBar(AppColors.darkBlue),
        _buildColorBar(AppColors.lightGrey),
        _buildColorBar(AppColors.softTeal),
        _buildColorBar(AppColors.vibrantBlue)
      ],
    );
  }

  // Widget para cada segmento de color
  Widget _buildColorBar(Color color) {
    return Expanded(
      flex: 1, // todos tienen el mismo ancho
      child: Container(
        height: height,
        color: color,
      ),
    );
  }

}