import 'package:flutter/material.dart';
import 'package:livria_user/features/book/presentation/widgets/single_book_view.dart';
import '../../../../common/theme/app_colors.dart';

class BookPage extends StatelessWidget {
  final String book;
  const BookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleBookView(book: book),
    );
  }
}

