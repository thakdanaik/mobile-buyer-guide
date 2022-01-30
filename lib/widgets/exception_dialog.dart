import 'package:flutter/material.dart';

class ExceptionDialog extends StatelessWidget {
  final String? title;
  final String? message;


  const ExceptionDialog({Key? key, this.title, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title ?? 'Exception',
            ),
          ),
        ],
      ),
      content: Text(
        message ?? '',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
              'Close',
              style: TextStyle(color: Colors.red)
          ),
        ),
      ],
    );
  }
}
