import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Services/task_service.dart';

import './View/screens/project_screen.dart';

import './Services/project_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProjectProvider>(
          create: (_) => ProjectProvider(),
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF1F1F9),
          fontFamily: "Poppins",
          primaryColor: Colors.blue,
          // splashColor: Colors.amber,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0),
            headlineLarge: TextStyle(
              fontFamily: "Kaushan",
              fontSize: 28,
              color: Colors.white,
              // color: Color.fromARGB(255, 49, 152, 225),
            ),
            labelMedium: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const ProjectsScreen(),
      ),
    );
  }
}
