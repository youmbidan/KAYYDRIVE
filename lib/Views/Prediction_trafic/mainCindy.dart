import 'package:flutter/material.dart';
import 'MainNavigationWrapper.dart';
import 'navigation.dart';
import 'notification.dart';
import 'Indication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayy Drive',
      debugShowCheckedModeBanner: false,
      home: const MainNavigationWrapper(),
    );
  }
}
