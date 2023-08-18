import 'package:final_presence_app/lesson/dtos/presence_dto.dart';
import 'package:final_presence_app/lesson/stores/lesson_store.dart';
import 'package:final_presence_app/shared/models/lesson.dart';
import 'package:final_presence_app/shared/models/presence.dart';
import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/repositories/repository.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/shared/states/dto_state.dart';
import 'package:final_presence_app/shared/utils/constants_util.dart';
import 'package:flutter/material.dart';

class LessonStoreImpl extends LessonStore {
  final Repository _repository;
  final ValueNotifier<DTOState> _dtoState = ValueNotifier(LoadingDTOState());

  LessonStoreImpl(super.value, this._repository);

  @override
  ValueNotifier<DTOState> get dtoState => _dtoState;

  @override
  Future<void> saveLesson(
      {required int schoolClass, DateTime? lessonDate}) async {
    value = LoadingState();
    try {
      Lesson lesson = Lesson.allArgs(
          id: 0, date: lessonDate ?? DateTime.now(), schoolClass: schoolClass);
      await _repository.saveLesson(lesson: lesson);
      findAllLessonsBySchoolClass(schoolClass: schoolClass);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> findAllLessonsBySchoolClass({required int schoolClass}) async {
    value = LoadingState();
    try {
      List<Lesson> lessons = await _repository.findAllLessonsBySchoolClass(
          schoolClass: schoolClass);
      value = LoadedState(models: lessons);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> deleteLesson(
      {required int lesson, required int schoolClass}) async {
    value = LoadingState();
    try {
      await _repository.deletePresencesByLesson(lesson: lesson);
      await _repository.deleteLesson(lesson: lesson);
      findAllLessonsBySchoolClass(schoolClass: schoolClass);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> savePresence({
    required int student,
    required lesson,
    required int schoolClass,
  }) async {
    dtoState.value = LoadingDTOState();
    try {
      Presence presence =
          Presence.allArgs(id: 0, student: student, lesson: lesson);
      presence = await _repository.savePresence(presence: presence);
      presence.wasSuccessfullySaved()
          ? findAllPresencesByLessonAndSchoolClass(
              lesson: lesson, schoolClass: schoolClass)
          : dtoState.value =
              ErrorDTOState(message: "Não foi possível cadastrar a presença.");
    } catch (error) {
      dtoState.value = ErrorDTOState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> findAllPresencesByLessonAndSchoolClass(
      {required int lesson, required int schoolClass}) async {
    dtoState.value = LoadingDTOState();
    try {
      List<PresenceDTO> dtos = [];
      List<Student> students = await _repository.findAllStudentsBySchoolClass(
          schoolClass: schoolClass);
      for (Student student in students) {
        final PresenceDTO dto = PresenceDTO.empty();
        List<Presence> presences =
            await _repository.findAllPresencesByStudentAndLesson(
                student: student.id!, lesson: lesson);
        dto.canInsertIntoList(presence: presences)
            ? dtos.add(PresenceDTO.allArgs(
                name: student.name, student: student.id, lesson: lesson))
            : null;
      }
      dtoState.value = LoadedDTOState(dtos: dtos);
    } catch (error) {
      dtoState.value = ErrorDTOState(message: ConstantsUtil.message);
    }
  }
}
