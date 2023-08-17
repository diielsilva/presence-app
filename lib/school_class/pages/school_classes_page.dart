import 'package:final_presence_app/school_class/stores/school_class_store.dart';
import 'package:final_presence_app/shared/components/alert_component.dart';
import 'package:final_presence_app/shared/components/insert_button_component.dart';
import 'package:final_presence_app/shared/components/loading_component.dart';
import 'package:final_presence_app/shared/enums/alert_type.dart';
import 'package:final_presence_app/shared/models/school_class.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:flutter/material.dart';

class SchoolClassesPage extends StatefulWidget {
  final SchoolClassStore store;

  const SchoolClassesPage({super.key, required this.store});

  @override
  State<SchoolClassesPage> createState() => _SchoolClassesPageState();
}

class _SchoolClassesPageState extends State<SchoolClassesPage> {
  late final SchoolClassStore _store;

  void _onInit() {
    _store = widget.store;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _store.findAllSchoolClasses();
    });
  }

  void _handleOptionButton(int option, int schoolClass) {
    switch (option) {
      case 0:
        Navigator.pushNamed(context, "/lessons", arguments: schoolClass);
        break;
      case 1:
        Navigator.pushNamed(context, "/students", arguments: schoolClass);
        break;
      case 2:
        _store.generatePdf(schoolClass: schoolClass);
        break;
      case 3:
        _store.deleteSchoolClass(schoolClass: schoolClass);
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
      onRefresh: _store.findAllSchoolClasses,
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
      appBar: AppBar(title: const Text("Turmas")),
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
            final List<SchoolClass> classes = state.models as List<SchoolClass>;

            return classes.isEmpty
                ? _alert(
                    message: "Não existem turmas cadastradas.",
                    icon: Icons.class_,
                    alertType: AlertType.standard)
                : ListView.builder(
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final SchoolClass schoolClass = classes[index];

                      return ListTile(
                        title: Text("Turma ${index + 1}"),
                        trailing: PopupMenuButton(
                          onSelected: (int option) =>
                              _handleOptionButton(option, schoolClass.id!),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text("Aulas"),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Alunos"),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text("Gerar Relatório"),
                            ),
                            const PopupMenuItem(
                              value: 3,
                              child: Text("Remover"),
                            )
                          ],
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
        onPressed: _store.saveSchoolClass,
      ),
    );
  }
}
