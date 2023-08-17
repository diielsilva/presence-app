import 'package:final_presence_app/shared/dtos/dto.dart';
import 'package:final_presence_app/shared/models/presence.dart';

class PresenceDTO implements DTO {
  String? name;
  int? student;
  int? lesson;

  PresenceDTO.empty();

  PresenceDTO.allArgs({
    required this.name,
    required this.student,
    required this.lesson,
  });

  bool canInsertIntoList({required List<Presence> presence}) {
    return presence.isEmpty;
  }
}
