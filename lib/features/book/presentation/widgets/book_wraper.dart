import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import '../../../auth/infrastructure/datasource/auth_remote_datasource.dart';
import '../../application/services/book_service.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository_impl.dart';
import '../../infrastructure/datasource/book_remote_datasource.dart';
import '../pages/book_page.dart';

class BookLoadingWrapper extends StatefulWidget {
  final int bookId;
  const BookLoadingWrapper({super.key, required this.bookId});

  @override
  State<BookLoadingWrapper> createState() => _BookLoadingWrapperState();
}

class _BookLoadingWrapperState extends State<BookLoadingWrapper> {
  late Future<Book?> _bookFuture;

  @override
  void initState() {
    super.initState();
    final service = BookService(BookRepositoryImpl(BookRemoteDataSource()));
    _bookFuture = service.findBookById(widget.bookId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Book?>(
      future: _bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(leading: const BackButton()),
            body: const Center(child: Text("Libro no encontrado")),
          );
        }

        return BookPage(
            b: snapshot.data!,
            authLocalDataSource: AuthLocalDataSource(),
            authRemoteDataSource: AuthRemoteDataSource()
        );
      },
    );
  }
}