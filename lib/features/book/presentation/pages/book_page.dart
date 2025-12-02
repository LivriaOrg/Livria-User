import 'package:flutter/material.dart';
import 'package:livria_user/features/auth/infrastructure/datasource/auth_local_datasource.dart';
import 'package:livria_user/features/auth/infrastructure/datasource/auth_remote_datasource.dart';
import 'package:livria_user/features/book/presentation/widgets/single_book_view.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/entities/book.dart';

class BookPage extends StatelessWidget {
  final Book b;
  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDataSource authRemoteDataSource;
  const BookPage({super.key, required this.b, required this.authLocalDataSource, required this.authRemoteDataSource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleBookView(b: b, authLocalDataSource: authLocalDataSource, authRemoteDataSource: authRemoteDataSource,),
    );
  }
}

