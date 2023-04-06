import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final bool? confirm;
  final Function onSubmit;
  final Text title;
  final Text description;

  const ConfirmationDialog(
      {Key? key,
      required this.confirm,
      required this.title,
      required this.description,
      required this.onSubmit})
      : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    bool? isConfirm = widget.confirm;
    if (isConfirm == null) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      return AlertDialog();
    }
    return AlertDialog(
      title: widget.title,
      actions: [
        ElevatedButton(
          onPressed: () => widget.onSubmit(),
          child: Text('Submit'),
        )
      ],
      content: widget.description,
    );
  }
}
