import 'package:final_presence_app/shared/components/alert_component.dart';
import 'package:final_presence_app/shared/components/insert_button_component.dart';
import 'package:final_presence_app/shared/components/loading_component.dart';
import 'package:final_presence_app/shared/enums/alert_type.dart';
import 'package:final_presence_app/shared/models/student.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/student/store/student_store.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  final StudentStore store;
  const StudentsPage({super.key, required this.store});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  late final int _schoolClass;
  late final StudentStore _store;
  Student _student = Student.empty();

  void _onInit() {
    _store = widget.store;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _schoolClass = ModalRoute.of(context)!.settings.arguments as int;
      _store.findAllStudentsBySchoolClass(schoolClass: _schoolClass);
      _student.schoolClass = _schoolClass;
    });
  }

  void _handleOptionButton({required int option, required int student}) {
    switch (option) {
      case 0:
        _displayForm(
            title: "Editar Aluno",
            isUpdate: true,
            label: "Editar",
            onSubmit: () => _store.updateStudent(student: _student));
        break;
      case 1:
        _store.deleteStudent(student: student);
        break;
    }
  }

  AlertComponent _alert({
    required String message,
    required IconData icon,
    required AlertType alertType,
  }) {
    return AlertComponent(
      message: message,
      icon: icon,
      alertType: alertType,
      onRefresh: () =>
          _store.findAllStudentsBySchoolClass(schoolClass: _schoolClass),
    );
  }

  Future<void> _displayForm({
    required String title,
    required String label,
    required bool isUpdate,
    required void Function() onSubmit,
  }) async {
    _store.formController.nameController.text = _student.name!;

    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 500,
            height: 300,
            child: Center(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _store.formController.key,
                child: TextFormField(
                  controller: _store.formController.nameController,
                  validator: _student.validator,
                  onChanged: (value) => _student.name = value,
                  decoration: const InputDecoration(hintText: "Nome"),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _store.formController.onSubmit(
                onSubmit: () async {
                  if (isUpdate) {
                    _store.updateStudent(student: _student);
                    Navigator.of(context).pop();
                  } else {
                    _store.saveStudent(student: _student);
                  }
                },
              ),
              child: Text(label),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _student = Student.empty();
              },
              child: const Text("Voltar"),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alunos")),
      body: ValueListenableBuilder(
        valueListenable: _store,
        builder: (context, state, child) {
          if (state is LoadingState) {
            return const LoadingComponent();
          }

          if (state is StoredState) {
            return _alert(
              message: state.message,
              icon: Icons.check_circle,
              alertType: AlertType.success,
            );
          }

          if (state is LoadedState) {
            final List<Student> students = state.models as List<Student>;

            return students.isEmpty
                ? _alert(
                    message: "Não existem alunos cadastrados.",
                    icon: Icons.school,
                    alertType: AlertType.standard,
                  )
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final Student student = students[index];

                      return ListTile(
                        title: Text(student.name!),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text("Editar"),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Remover"),
                            )
                          ],
                          onSelected: (int option) {
                            _student = Student.allArgs(
                              id: student.id!,
                              name: student.name!,
                              schoolClass: student.schoolClass!,
                            );
                            _handleOptionButton(
                                option: option, student: student.id!);
                          },
                        ),
                      );
                    },
                  );
          }

          if (state is ErrorState) {
            return _alert(
              message: state.message,
              icon: Icons.error,
              alertType: AlertType.error,
            );
          }

          return Container();
        },
      ),
      floatingActionButton: InsertButtonComponent(
        onPressed: () {
          _student =
              Student.allArgs(id: 0, name: "", schoolClass: _schoolClass);
          _displayForm(
            title: "Cadastrar Aluno",
            isUpdate: false,
            label: "Cadastrar",
            onSubmit: () => _store.saveStudent(student: _student),
          );
        },
      ),
    );
  }
}
