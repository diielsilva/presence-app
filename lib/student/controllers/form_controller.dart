import 'package:flutter/material.dart';

abstract interface class FormController {
  GlobalKey<FormState> get key;

  TextEditingController get nameController;

  Future<void> onSubmit({required void Function() onSubmit});

  void reset();
}
