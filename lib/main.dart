import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_theme.dart';
import 'package:livria_user/common/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:livria_user/common/di/dependencies.dart' as di;

import 'features/orders/domain/usecases/get_user_orders_usecase.dart';
import 'features/orders/presentation/providers/order_provider.dart';
import 'features/orders/domain/usecases/create_order_usecase.dart';
import 'features/orders/infrastructure/repositories/order_repository_impl.dart';
import 'features/orders/infrastructure/datasource/order_remote_datasource.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'features/profile/infrastructure/datasource/profile_remote_datasource.dart';
import 'features/profile/infrastructure/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initializeDependencies();

  Stripe.publishableKey = "pk_test_51SYEEjCT8H4q0SwHXOXEueZELjE8n2mE2HO2RePX2sUBNn2sWUo85aROv82Cz1CxYNMBrXB3MfghckoOFsYd56sB00XotlaES0";

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    _initializeStripe();
  }

  Future<void> _initializeStripe() async {
    try {
      await Stripe.instance.applySettings();
      debugPrint("Stripe settings applied correctly");
    } catch (e) {
      debugPrint("Stripe init error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ORDER PROVIDER (Para el Checkout)
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            createOrderUseCase: CreateOrderUseCase(
              OrderRepositoryImpl(
                OrderRemoteDataSource(client: http.Client()),
              ),
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            // A. Repositorio de Perfil
            profileRepository: ProfileRepositoryImpl(
              ProfileRemoteDataSource(client: http.Client()),
            ),

            // B. Caso de Uso de Órdenes (Historial de compras)
            getUserOrdersUseCase: GetUserOrdersUseCase(
              OrderRepositoryImpl(
                OrderRemoteDataSource(client: http.Client()),
              ),
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
