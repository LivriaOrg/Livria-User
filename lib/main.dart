import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_theme.dart';

import 'package:livria_user/common/routes/app_router.dart';

void main() => runApp(const MyApp());

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






// Fonts Example
//
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Custom Fonts',
//           style: Theme.of(context).textTheme.headlineLarge,
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Hola (Texto 1)',
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                 fontSize: 70,
//                 color: AppColors.primaryOrange
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             Text(
//               'Hola (Texto 2)',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }