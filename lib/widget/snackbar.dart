import 'package:flutter/material.dart';

extension Snackbar on BuildContext {
  ScaffoldFeatureController showSnackbar(
      {required String title,
      String? actionLabel,
      void Function()? onPressed}) {
    assert((actionLabel == null) == (onPressed == null));

    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        content: Text(title),
        action: actionLabel != null
            ? SnackBarAction(
                key: const Key('snackbar-action-button'),
                label: actionLabel,
                onPressed: onPressed!,
              )
            : null,
      ),
    );
  }
}
