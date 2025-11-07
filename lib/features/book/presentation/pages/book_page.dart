import 'package:flutter/material.dart';
import 'package:livria_user/features/book/presentation/widgets/single_book_view.dart';
import '../../../../common/theme/app_colors.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleBookView(),
    );
  }
}

