import 'package:final_presence_app/shared/models/model.dart';

class Student extends Model {
  String? name;
  int? schoolClass;

  Student.empty();

  Student.allArgs(
      {required int id, required this.name, required this.schoolClass}) {
    super.id = id;
  }

  Student.fromMap({required Map<String, dynamic> map}) {
    id = map["id"];
    name = map["name"];
    schoolClass = map["school_class"];
  }

  @override
  bool canSave() {
    return name != null &&
        name!.isNotEmpty &&
        schoolClass != null &&
        schoolClass! > 0;
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "O campo nome é obrigatório.";
    }
    return null;
  }
}
