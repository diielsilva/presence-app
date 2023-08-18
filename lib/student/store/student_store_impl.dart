import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/repositories/repository.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/shared/utils/constants_util.dart';
import 'package:final_presence_app/student/controllers/form_controller.dart';
import 'package:final_presence_app/student/store/student_store.dart';

class StudentStoreImpl extends StudentStore {
  final Repository _repository;
  final FormController _controller;

  StudentStoreImpl(super.value, this._repository, this._controller);

  @override
  FormController get formController => _controller;

  @override
  Future<void> saveStudent({required Student student}) async {
    value = LoadingState();
    try {
      await _repository.saveStudent(student: student);
      findAllStudentsBySchoolClass(schoolClass: student.schoolClass!);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> findAllStudentsBySchoolClass({required int schoolClass}) async {
    value = LoadingState();
    try {
      List<Student> students = await _repository.findAllStudentsBySchoolClass(
          schoolClass: schoolClass);
      value = LoadedState(models: students);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> updateStudent({required Student student}) async {
    value = LoadingState();
    try {
      await _repository.updateStudent(student: student);
      findAllStudentsBySchoolClass(schoolClass: student.schoolClass!);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }

  @override
  Future<void> deleteStudent(
      {required int student, required int schoolClass}) async {
    value = LoadingState();
    try {
      await _repository.deletePresencesByStudent(student: student);
      await _repository.deleteStudent(student: student);
      findAllStudentsBySchoolClass(schoolClass: schoolClass);
    } catch (error) {
      value = ErrorState(message: ConstantsUtil.message);
    }
  }
}
