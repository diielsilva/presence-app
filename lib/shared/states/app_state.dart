import 'package:final_presence_app/shared/models/model.dart';

abstract interface class AppState {}

class LoadingState implements AppState {}

class LoadedState implements AppState {
  final List<Model> models;

  LoadedState({required this.models});
}

class ErrorState implements AppState {
  final String message;

  ErrorState({required this.message});
}
