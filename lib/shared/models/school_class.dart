import 'package:final_presence_app/shared/models/model.dart';

class SchoolClass extends Model {
  SchoolClass.empty();

  SchoolClass.allArgs({required int id}) {
    super.id = id;
  }

  SchoolClass.fromMap({required Map<String, dynamic> map}) {
    id = map["id"];
  }

  @override
  bool canSave() {
    return id == null;
  }
}
