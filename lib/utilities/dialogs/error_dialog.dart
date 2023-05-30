import 'package:flutter/material.dart';
import 'package:movies/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "An error ocurred",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
