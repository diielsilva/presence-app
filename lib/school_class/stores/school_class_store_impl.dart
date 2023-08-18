import 'package:final_presence_app/school_class/controllers/pdf_controller.dart';
import 'package:final_presence_app/school_class/dtos/export_dto.dart';
import 'package:final_presence_app/school_class/stores/school_class_store.dart';
import 'package:final_presence_app/shared/models/lesson.dart';
import 'package:final_presence_app/shared/models/presence.dart';
import 'package:final_presence_app/shared/models/school_class.dart';
import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/repositories/repository.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/shared/utils/message_util.dart';

class SchoolClassStoreImpl extends SchoolClassStore {
  final Repository _repository;
  final PdfController _controller;

  SchoolClassStoreImpl(super.value, this._repository, this._controller);

  @override
  Future<void> saveSchoolClass() async {
    value = LoadingState();
    try {
      SchoolClass schoolClass = await _repository.saveSchoolClass();
      schoolClass.wasSuccessfullySaved()
          ? value = StoredState(message: "Turma cadastrada com sucesso.")
          : value = ErrorState(message: "Não foi possível cadastrar a turma.");
      _delayToDisplayMessage();
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
    }
  }

  @override
  Future<void> findAllSchoolClasses() async {
    value = LoadingState();
    try {
      List<SchoolClass> classes = await _repository.findAllSchoolClasses();
      value = LoadedState(models: classes);
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
    }
  }

  @override
  Future<void> deleteSchoolClass({required int schoolClass}) async {
    value = LoadingState();
    try {
      List<Lesson> lessons = await _repository.findAllLessonsBySchoolClass(
          schoolClass: schoolClass);
      for (Lesson lesson in lessons) {
        await _repository.deletePresencesByLesson(lesson: lesson.id!);
        await _repository.deleteLesson(lesson: lesson.id!);
      }
      List<Student> students = await _repository.findAllStudentsBySchoolClass(
          schoolClass: schoolClass);
      for (Student student in students) {
        await _repository.deleteStudent(student: student.id!);
      }
      await _repository.deleteSchoolClass(schoolClass: schoolClass);
      value = StoredState(message: "Turma removida com sucesso.");
      _delayToDisplayMessage();
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
    }
  }

  @override
  Future<void> generatePdf({required int schoolClass}) async {
    try {
      List<ExportDTO> dtos = [];
      List<Lesson> lessons = await _repository.findAllLessonsBySchoolClass(
          schoolClass: schoolClass);
      List<Student> students = await _repository.findAllStudentsBySchoolClass(
          schoolClass: schoolClass);

      for (Student student in students) {
        List<Presence> presences =
            await _repository.findAllPresencesByStudent(student: student.id!);
        ExportDTO dto =
            ExportDTO.allArgs(name: student.name, presences: presences.length);
        dto.calculateAbsences(lessons.length);
        dtos.add(dto);
      }

      await _controller.generatePDF(dtos: dtos, lessons: lessons.length);
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
    }
  }

  Future<void> _delayToDisplayMessage() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
      () {
        findAllSchoolClasses();
      },
    );
  }
}
