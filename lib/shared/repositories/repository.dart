import 'package:final_presence_app/shared/models/lesson.dart';
import 'package:final_presence_app/shared/models/presence.dart';
import 'package:final_presence_app/shared/models/school_class.dart';
import 'package:final_presence_app/shared/models/student.dart';

abstract interface class Repository {
  Future<SchoolClass> saveSchoolClass();

  Future<List<SchoolClass>> findAllSchoolClasses();

  Future<void> deleteSchoolClass({required int schoolClass});

  Future<Student> saveStudent({required Student student});

  Future<List<Student>> findAllStudentsBySchoolClass(
      {required int schoolClass});

  Future<void> updateStudent({required Student student});

  Future<void> deleteStudent({required int student});

  Future<Lesson> saveLesson({required Lesson lesson});

  Future<List<Lesson>> findAllLessonsBySchoolClass({required int schoolClass});

  Future<void> deleteLesson({required int lesson});

  Future<Presence> savePresence({required Presence presence});

  Future<List<Presence>> findAllPresencesByStudentAndLesson(
      {required int student, required int lesson});

  Future<List<Presence>> findAllPresencesByStudent({required int student});

  Future<void> deletePresencesByStudent({required int student});

  Future<void> deletePresencesByLesson({required int lesson});
}
