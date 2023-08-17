import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:flutter/material.dart';

abstract class SchoolClassStore extends ValueNotifier<AppState> {
  SchoolClassStore(super.value);

  Future<void> saveSchoolClass();

  Future<void> findAllSchoolClasses();

  Future<void> deleteSchoolClass({required int schoolClass});

  Future<void> generatePdf({required int schoolClass});
}
