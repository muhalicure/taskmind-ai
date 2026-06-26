import 'package:flutter/material.dart';
import 'package:taskmind_ai/business/notification_service.dart';
import 'package:taskmind_ai/business/theme_service.dart';
import 'package:taskmind_ai/ui/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.init();
  await ThemeService.instance.loadTheme();

  runApp(const TaskMindApp());
}

class TaskMindApp extends StatelessWidget {
  const TaskMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.instance.isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'TaskMind AI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Arial',
            scaffoldBackgroundColor:
                isDark ? const Color(0xFF111111) : const Color(0xFFFAFAFA),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}