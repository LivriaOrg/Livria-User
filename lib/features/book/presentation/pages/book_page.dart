import 'package:flutter/material.dart';
import 'package:livria_user/features/book/presentation/widgets/single_book_view.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/book.dart';

class BookPage extends StatelessWidget {
  final Book b;
  const BookPage({super.key, required this.b});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleBookView(b: b),
    );
  }
}

