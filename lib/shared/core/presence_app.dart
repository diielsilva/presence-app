import 'package:final_presence_app/lesson/pages/lessons_page.dart';
import 'package:final_presence_app/school_class/pages/school_classes_page.dart';
import 'package:final_presence_app/shared/injectors/injector.dart';
import 'package:final_presence_app/student/pages/students_page.dart';
import 'package:flutter/material.dart';

class PresenceApp extends StatelessWidget {
  final Injector _injector;

  const PresenceApp(this._injector, {super.key});

  Map<String, WidgetBuilder> _routes() {
    return {
      "/": (context) => SchoolClassesPage(store: _injector.schoolClassStore),
      "/students": (context) => StudentsPage(store: _injector.studentStore),
      "/lessons": (context) => LessonsPage(store: _injector.lessonStore)
    };
  }

  ThemeData _getTheme({required Brightness brightness}) {
    const Color color = Color.fromARGB(249, 236, 102, 154);

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: color,
      brightness: brightness,
      appBarTheme: const AppBarTheme(backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _routes(),
      theme: _getTheme(brightness: Brightness.light),
      darkTheme: _getTheme(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
    );
  }
}
