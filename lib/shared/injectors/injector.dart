import 'package:final_presence_app/lesson/stores/lesson_store.dart';
import 'package:final_presence_app/school_class/stores/school_class_store.dart';
import 'package:final_presence_app/student/store/student_store.dart';

abstract interface class Injector {
  SchoolClassStore get schoolClassStore;

  StudentStore get studentStore;

  LessonStore get lessonStore;
}
