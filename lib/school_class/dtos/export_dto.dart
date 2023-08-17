import 'package:final_presence_app/shared/dtos/dto.dart';

class ExportDTO implements DTO {
  String? name;
  int? presences;
  int? _absences;

  ExportDTO.allArgs({required this.name, required this.presences});

  int get absences => _absences!;

  void calculateAbsences(int lessonAmount) {
    if (presences != null) {
      _absences = lessonAmount - presences!;
    }
  }
}
