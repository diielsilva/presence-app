import 'package:final_presence_app/student/controllers/form_controller.dart';
import 'package:flutter/material.dart';

class FormControllerImpl implements FormController {
  static FormControllerImpl? _instance;
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _nameController = TextEditingController();

  FormControllerImpl._();

  static FormController get instance => _instance ??= FormControllerImpl._();

  @override
  GlobalKey<FormState> get key => _key;

  @override
  TextEditingController get nameController => _nameController;

  @override
  Future<void> onSubmit({required void Function() onSubmit}) async {
    if (_key.currentState!.validate()) {
      onSubmit();
      reset();
    }
  }

  @override
  void reset() {
    _key.currentState?.reset();
  }
}
