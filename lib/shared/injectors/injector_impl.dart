import 'package:final_presence_app/lesson/stores/lesson_store.dart';
import 'package:final_presence_app/lesson/stores/lesson_store_impl.dart';
import 'package:final_presence_app/school_class/controllers/pdf_controller_impl.dart';
import 'package:final_presence_app/school_class/stores/school_class_store.dart';
import 'package:final_presence_app/school_class/stores/school_class_store_impl.dart';
import 'package:final_presence_app/shared/injectors/injector.dart';
import 'package:final_presence_app/shared/repositories/repository_impl.dart';
import 'package:final_presence_app/shared/states/app_state.dart';
import 'package:final_presence_app/student/controllers/form_controller_impl.dart';
import 'package:final_presence_app/student/store/student_store.dart';
import 'package:final_presence_app/student/store/student_store_impl.dart';

class InjectorImpl implements Injector {
  static InjectorImpl? _instance;
  SchoolClassStore? _schoolClassStore;
  StudentStore? _studentStore;
  LessonStore? _lessonStore;

  InjectorImpl._();

  static Injector get instance => _instance ??= InjectorImpl._();

  @override
  SchoolClassStore get schoolClassStore =>
      _schoolClassStore ??= SchoolClassStoreImpl(
        LoadingState(),
        RepositoryImpl.instance,
        PdfControllerImpl.instance
      );

  @override
  StudentStore get studentStore => _studentStore ??= StudentStoreImpl(
        LoadingState(),
        RepositoryImpl.instance,
        FormControllerImpl.instance,
      );

  @override
  LessonStore get lessonStore => _lessonStore ??= LessonStoreImpl(
        LoadingState(),
        RepositoryImpl.instance,
      );
}
