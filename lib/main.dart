import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout/data/workout_data.dart';
import 'pages/home_page.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("workout_database1");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue, // AppBar background color
            foregroundColor: Colors.white, // Text and icon color
            centerTitle: true, // Center the AppBar title
            elevation: 3, // Add shadow to the AppBar
            shadowColor: Colors.black, // Shadow color
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, // FAB background color matches AppBar
            foregroundColor: Colors.white, // Icon color in FAB
          ),
          dialogTheme: DialogTheme(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Set rounded corners
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.grey.shade300, // Grey background for chips
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Fully round chip shape
            ),
            labelStyle: const TextStyle(
              color: Colors.black, // Text color inside the chip
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue), // AppBar color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2), // AppBar color, thicker for focus
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}