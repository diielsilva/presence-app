import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/repositories/repository.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/shared/utils/message_util.dart';
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
      if (student.canSave()) {
        student = await _repository.saveStudent(student: student);
        student.wasSuccessfullySaved()
            ? value = StoredState(message: "Aluno cadastrado com sucesso.")
            : value =
                ErrorState(message: "Não foi possível cadastrar o aluno.");
      } else {
        value = ErrorState(message: "O aluno fornecido é inválido.");
      }
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
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
      value = ErrorState(message: MessageUtil.message);
    }
  }

  @override
  Future<void> deleteStudent({required int student}) async {
    value = LoadingState();
    try {
      await _repository.deletePresencesByStudent(student: student);
      await _repository.deleteStudent(student: student);
      value = StoredState(message: "Aluno removido com sucesso.");
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
    }
  }

  @override
  Future<void> updateStudent({required Student student}) async {
    value = LoadingState();
    try {
      if (student.canSave()) {
        await _repository.updateStudent(student: student);
        value = StoredState(message: "Aluno alterado com sucesso.");
      } else {
        value = ErrorState(message: "O aluno fornecido é inválido.");
      }
    } catch (error) {
      value = ErrorState(message: MessageUtil.message);
    }
  }
}