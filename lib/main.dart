import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel6assignment/screens/home_screen.dart';

import 'services/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Init().initialize();
  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },
    child: MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: 'Flutter Assignment',
    home: const HomeScreen()),
    );
  }
}
