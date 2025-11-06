import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_theme.dart';
import 'package:livria_user/common/routes/app_router.dart';

import 'package:livria_user/common/di/dependencies.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Livria',
      theme: getAppTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}