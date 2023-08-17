import 'package:final_presence_app/shared/models/lesson.dart';
import 'package:final_presence_app/shared/models/presence.dart';
import 'package:final_presence_app/shared/models/school_class.dart';
import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/repositories/repository.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RepositoryImpl implements Repository {
  Database? _connection;
  static RepositoryImpl? _instance;

  static RepositoryImpl get instance => _instance ??= RepositoryImpl._();

  RepositoryImpl._();

  Future<void> _onCreate(Database database, int version) async {
    await database.execute(''' 
      CREATE TABLE SchoolClass (
      id INTEGER PRIMARY KEY AUTOINCREMENT
      );
    ''');
    await database.execute('''
      CREATE TABLE Student (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      school_class INTEGER NOT NULL,
      FOREIGN KEY(school_class) REFERENCES SchoolClass(id)
      );
    ''');
    await database.execute('''
      CREATE TABLE Lesson (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date NUMERIC NOT NULL,
      school_class INTEGER NOT NULL,
      FOREIGN KEY(school_class) REFERENCES SchoolClass(id)  
      );
    ''');
    await database.execute('''
      CREATE TABLE Presence (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student INTEGER NOT NULL,
      lesson INTEGER NOT NULL,
      FOREIGN KEY(student) REFERENCES Student(id),
      FOREIGN KEY(lesson) REFERENCES Lesson(id)
      );
    ''');
  }

  Future<Database> _openConnection() async {
    sqfliteFfiInit();
    String folder = await databaseFactoryFfi.getDatabasesPath();
    String databasePath = join(folder, 'app.db');
    DatabaseFactory factory = databaseFactoryFfi;
    return _connection ??= await factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(onCreate: _onCreate, version: 1),
    );
  }

  Future<int> _rawInsert({required String sql}) async {
    _connection = await _openConnection();
    return await _connection!.rawInsert(sql);
  }

  Future<List<Map<String, dynamic>>> _rawQuery({required String sql}) async {
    _connection = await _openConnection();
    return await _connection!.rawQuery(sql);
  }

  Future<int> _rawUpdate({required String sql}) async {
    _connection = await _openConnection();
    return await _connection!.rawUpdate(sql);
  }

  Future<void> _rawDelete({required String sql}) async {
    await _connection!.rawDelete(sql);
  }

  @override
  Future<SchoolClass> saveSchoolClass() async {
    int id = await _rawInsert(sql: "INSERT INTO SchoolClass VALUES (NULL)");
    return SchoolClass.allArgs(id: id);
  }

  @override
  Future<List<SchoolClass>> findAllSchoolClasses() async {
    List<Map<String, dynamic>> rows =
        await _rawQuery(sql: "SELECT * FROM SchoolClass");
    return rows
        .map((row) => SchoolClass.fromMap(map: row))
        .toList(growable: false);
  }

  @override
  Future<void> deleteSchoolClass({required int schoolClass}) async {
    await _rawDelete(sql: "DELETE FROM SchoolClass WHERE id = $schoolClass");
  }

  @override
  Future<Student> saveStudent({required Student student}) async {
    int id = await _rawInsert(
        sql:
            "INSERT INTO Student VALUES (NULL,'${student.name}', ${student.schoolClass})");
    return Student.allArgs(
        id: id, name: student.name, schoolClass: student.schoolClass);
  }

  @override
  Future<List<Student>> findAllStudentsBySchoolClass(
      {required int schoolClass}) async {
    List<Map<String, dynamic>> rows = await _rawQuery(
        sql:
            "SELECT * FROM Student WHERE school_class = $schoolClass ORDER BY name");
    return rows.map((row) => Student.fromMap(map: row)).toList(growable: false);
  }

  @override
  Future<void> updateStudent({required Student student}) async {
    await _rawUpdate(
        sql:
            "UPDATE Student SET name = '${student.name}' WHERE id = ${student.id}");
  }

  @override
  Future<void> deleteStudent({required int student}) async {
    await _rawDelete(sql: "DELETE FROM Student WHERE id = $student");
  }

  @override
  Future<Lesson> saveLesson({required Lesson lesson}) async {
    int id = await _rawInsert(
        sql:
            "INSERT INTO Lesson VALUES (NULL, ${lesson.date!.millisecondsSinceEpoch}, ${lesson.schoolClass})");
    return Lesson.allArgs(
        id: id, date: lesson.date, schoolClass: lesson.schoolClass);
  }

  @override
  Future<List<Lesson>> findAllLessonsBySchoolClass(
      {required int schoolClass}) async {
    List<Map<String, dynamic>> rows = await _rawQuery(
        sql: "SELECT * FROM Lesson WHERE school_class = $schoolClass ORDER BY date");
    return rows.map((row) => Lesson.fromMap(map: row)).toList(growable: false);
  }

  @override
  Future<void> deleteLesson({required int lesson}) async {
    await _rawDelete(sql: "DELETE FROM Lesson WHERE id = $lesson");
  }

  @override
  Future<Presence> savePresence({required Presence presence}) async {
    int id = await _rawInsert(
        sql:
            "INSERT INTO Presence VALUES (NULL, ${presence.student}, ${presence.lesson})");
    return Presence.allArgs(
        id: id, student: presence.student, lesson: presence.lesson);
  }

  @override
  Future<List<Presence>> findAllPresencesByStudentAndLesson(
      {required int student, required int lesson}) async {
    List<Map<String, dynamic>> rows = await _rawQuery(
        sql:
            "SELECT * FROM Presence WHERE student = $student AND lesson = $lesson");
    return rows
        .map((row) => Presence.fromMap(map: row))
        .toList(growable: false);
  }

  @override
  Future<List<Presence>> findAllPresencesByStudent(
      {required int student}) async {
    List<Map<String, dynamic>> rows =
        await _rawQuery(sql: "SELECT * FROM Presence WHERE student = $student");
    return rows
        .map((row) => Presence.fromMap(map: row))
        .toList(growable: false);
  }

  @override
  Future<void> deletePresencesByStudent({required int student}) async {
    await _rawDelete(sql: "DELETE FROM Presence WHERE student = $student");
  }

  @override
  Future<void> deletePresencesByLesson({required int lesson}) async {
    await _rawDelete(sql: "DELETE FROM Presence WHERE lesson = $lesson");
  }
}
