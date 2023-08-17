import 'dart:ui';

import 'package:final_presence_app/shared/enums/alert_type.dart';
import 'package:flutter/material.dart';

class AlertComponent extends StatelessWidget {
  final String message;
  final IconData icon;
  final AlertType alertType;
  final Future<void> Function() onRefresh;

  const AlertComponent({
    super.key,
    required this.message,
    required this.icon,
    required this.alertType,
    required this.onRefresh,
  });

  Color _alertTypeColor() {
    switch (alertType) {
      case AlertType.error:
        return Colors.red;
      case AlertType.success:
        return Colors.green;
      case AlertType.standard:
        return const Color.fromARGB(249, 236, 102, 154);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      color: _alertTypeColor(),
                      size:
                          MediaQuery.of(context).size.width > 600 ? 270 : 150),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 600 ? 25 : 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
