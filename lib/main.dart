import 'package:flutter/material.dart';
import 'package:laundry_system/app_colours.dart';
import 'package:laundry_system/widgets/laundry_home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laundry App',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mintGreen,
          brightness: Brightness.light,
          surface: AppColors.cream,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mintGreen,
          foregroundColor: AppColors.charcoal,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.charcoal),
        ),
      ),
      home: const LaundryHome(),
    );
  }
}