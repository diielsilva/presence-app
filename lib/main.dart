import 'package:final_presence_app/shared/core/presence_app.dart';
import 'package:final_presence_app/shared/injectors/injector_impl.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(PresenceApp(InjectorImpl.instance));
}
