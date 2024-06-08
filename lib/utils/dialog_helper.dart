import 'package:flutter/material.dart';

class DialogHelper {
  static void showAlertDialog(
    BuildContext buildContext,
    String title,
    String message,
    VoidCallback? completeCallback, {
    bool showCancelButton = true,
  }) {
    ElevatedButton cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(buildContext).pop();
      },
      child: const Text('Cancel'),
    );

    ElevatedButton continueButton = ElevatedButton(
      onPressed: () {
        Navigator.of(buildContext).pop();
        completeCallback?.call();
      },
      child: const Text('Ok'),
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (showCancelButton) cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
