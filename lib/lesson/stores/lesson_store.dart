import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/shared/states/dto_state.dart';
import 'package:flutter/material.dart';

abstract class LessonStore extends ValueNotifier<AppState> {
  LessonStore(super.value);

  ValueNotifier<DTOState> get dtoState;

  Future<void> saveLesson({required int schoolClass, DateTime? lessonDate});

  Future<void> findAllLessonsBySchoolClass({required int schoolClass});

  Future<void> deleteLesson({required int lesson, required int schoolClass});

  Future<void> savePresence({
    required int student,
    required int lesson,
    required int schoolClass,
  });

  Future<void> findAllPresencesByLessonAndSchoolClass(
      {required int lesson, required int schoolClass});
}
