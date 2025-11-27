import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_theme.dart';
import 'package:livria_user/common/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:livria_user/common/di/dependencies.dart' as di;

import 'features/orders/presentation/providers/order_provider.dart';
import 'features/orders/domain/usecases/create_order_usecase.dart';
import 'features/orders/infrastructure/repositories/order_repository_impl.dart';
import 'features/orders/infrastructure/datasource/order_remote_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            createOrderUseCase: CreateOrderUseCase(
                OrderRepositoryImpl(
                    OrderRemoteDataSource(client: http.Client())
                )
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Livria',
        theme: getAppTheme(),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}