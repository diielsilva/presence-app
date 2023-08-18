import 'package:flutter/material.dart';

extension MessageExtension on BuildContext {
  void showSuccessMessage({required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
