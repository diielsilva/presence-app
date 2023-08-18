import 'package:final_presence_app/lesson/dtos/presence_dto.dart';
import 'package:final_presence_app/lesson/stores/lesson_store.dart';
import 'package:final_presence_app/shared/components/alert_component.dart';
import 'package:final_presence_app/shared/components/insert_button_component.dart';
import 'package:final_presence_app/shared/components/loading_component.dart';
import 'package:final_presence_app/shared/enums/alert_type.dart';
import 'package:final_presence_app/shared/models/lesson.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/shared/states/dto_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonsPage extends StatefulWidget {
  final LessonStore store;

  const LessonsPage({super.key, required this.store});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  late final LessonStore _store;
  late final int _schoolClass;

  void _onInit() {
    _store = widget.store;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _schoolClass = ModalRoute.of(context)!.settings.arguments as int;
      _store.findAllLessonsBySchoolClass(schoolClass: _schoolClass);
    });
  }

  void _handleOptionButton({required int option, required int lesson}) {
    switch (option) {
      case 0:
        _displayDTOS(lesson: lesson);
        break;
      case 1:
        _store.deleteLesson(lesson: lesson, schoolClass: _schoolClass);
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
          _store.findAllLessonsBySchoolClass(schoolClass: _schoolClass),
    );
  }

  Future<void> _displayDTOS({required int lesson}) async {
    _store.findAllPresencesByLessonAndSchoolClass(
        lesson: lesson, schoolClass: _schoolClass);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Atribuir Presenças"),
          content: SizedBox(
            width: 500,
            height: 300,
            child: ValueListenableBuilder(
              valueListenable: _store.dtoState,
              builder: (context, state, child) {
                if (state is LoadingDTOState) {
                  return const LoadingComponent();
                }

                if (state is LoadedDTOState) {
                  final List<PresenceDTO> dtos =
                      state.dtos as List<PresenceDTO>;

                  return dtos.isEmpty
                      ? const Center(
                          child: Text(
                            "Todos os alunos estão presentes ou não existem alunos cadastrados.",
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: dtos.length,
                          itemBuilder: (context, index) {
                            final PresenceDTO dto = dtos[index];

                            return ListTile(
                              title: Text(dto.name!),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () => _store.savePresence(
                                  student: dto.student!,
                                  lesson: dto.lesson!,
                                  schoolClass: _schoolClass,
                                ),
                              ),
                            );
                          },
                        );
                }

                return Container();
              },
            ),
          ),
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
      appBar: AppBar(title: const Text("Aulas")),
      body: ValueListenableBuilder(
        valueListenable: _store,
        builder: (context, state, child) {
          if (state is LoadingState) {
            return const LoadingComponent();
          }

          if (state is LoadedState) {
            final List<Lesson> lessons = state.models as List<Lesson>;

            return lessons.isEmpty
                ? _alert(
                    message: "Não existem aulas cadastradas.",
                    icon: Icons.school_rounded,
                    alertType: AlertType.standard,
                  )
                : ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final Lesson lesson = lessons[index];

                      return ListTile(
                        title: Text("Aula ${index + 1}"),
                        subtitle: Text(
                          DateFormat("dd/MM/yyyy").format(lesson.date!),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text("Atribuir Presenças"),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Remover"),
                            )
                          ],
                          onSelected: (option) => _handleOptionButton(
                              option: option, lesson: lesson.id!),
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
        onPressed: () async {
          DateTime? lessonDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now(),
          );
          if (lessonDate != null) {
            _store.saveLesson(
              schoolClass: _schoolClass,
              lessonDate: lessonDate,
            );
          }
        },
      ),
    );
  }
}
