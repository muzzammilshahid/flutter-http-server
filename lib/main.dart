import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'backgroundService/background_service_class.dart';
import 'home_screen.ddart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PermissionStatus permissionStatus =
      await Permission.notification.request();
  if (permissionStatus == PermissionStatus.granted) {
    await initializeService();
  } else {
    print(
        'Notification permission denied. Background service will not be started.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP SERVER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
