import 'package:final_presence_app/shared/core/presence_app.dart';
import 'package:final_presence_app/shared/injectors/injector_impl.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setWindowMinSize(const Size(800, 600));

  runApp(PresenceApp(InjectorImpl.instance));
}
