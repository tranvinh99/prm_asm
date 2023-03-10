import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
      BuildContext context, String message, String label, VoidCallback action) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
        action: SnackBarAction(
          label: label,
          onPressed: action,
        ),
      ),
    );
  }
}
