import 'package:flutter/material.dart';

void snackBar(BuildContext context,
    {required String message,
      required Color colorOfMessage,
      required Color colorOfText}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorOfMessage,
      content: Text(
        message,
        style: TextStyle(color: colorOfText),
      ),
    ),
  );
}