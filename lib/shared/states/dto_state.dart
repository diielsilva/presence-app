import 'package:final_presence_app/shared/dtos/dto.dart';

abstract interface class DTOState {}

class LoadingDTOState implements DTOState {}

class LoadedDTOState implements DTOState {
  final List<DTO> dtos;

  LoadedDTOState({required this.dtos});
}

class ErrorDTOState implements DTOState {
  final String message;

  ErrorDTOState({required this.message});
}
