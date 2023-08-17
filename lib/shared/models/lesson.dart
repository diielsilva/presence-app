import 'package:final_presence_app/shared/models/model.dart';

class Lesson extends Model {
  DateTime? date;
  int? schoolClass;

  Lesson.empty();

  Lesson.allArgs({
    required int id,
    required this.date,
    required this.schoolClass,
  }) {
    super.id = id;
  }

  Lesson.fromMap({required Map<String, dynamic> map}) {
    id = map["id"];
    date = DateTime.fromMillisecondsSinceEpoch(map["date"]);
    schoolClass = map["school_class"];
  }

  @override
  bool canSave() {
    return date != null && schoolClass != null && schoolClass! > 0;
  }
}
