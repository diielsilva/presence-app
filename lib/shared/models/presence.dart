import 'package:final_presence_app/shared/models/model.dart';

class Presence extends Model {
  int? student;
  int? lesson;

  Presence.empty();

  Presence.allArgs(
      {required int id, required this.student, required this.lesson}) {
    super.id = id;
  }

  Presence.fromMap({required Map<String, dynamic> map}) {
    id = map["id"];
    student = map["student"];
    lesson = map["lesson"];
  }

  @override
  bool canSave() {
    return student != null && student! > 0 && lesson != null && lesson! > 0;
  }
}
