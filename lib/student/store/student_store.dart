import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/student/controllers/form_controller.dart';
import 'package:flutter/material.dart';

abstract class StudentStore extends ValueNotifier<AppState> {
  StudentStore(super.value);

  FormController get formController;

  Future<void> saveStudent({required Student student});

  Future<void> findAllStudentsBySchoolClass({required int schoolClass});

  Future<void> updateStudent({required Student student});

  Future<void> deleteStudent({required int student});
}
