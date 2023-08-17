import 'package:flutter/material.dart';

class InsertButtonComponent extends StatelessWidget {
  final void Function() onPressed;

  const InsertButtonComponent({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
