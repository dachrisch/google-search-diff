import 'package:flutter/material.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    var searchServiceProvider = context.read<SearchServiceProvider>();
    return IconButton(
      key: const Key('goto-login-button'),
      tooltip: 'Back to login',
      onPressed: () => searchServiceProvider.isTrying
          ? context.goToEnter()
          : _showConfirmationDialog(context),
      icon: const Icon(Icons.login_outlined),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var searchServiceProvider = context.read<SearchServiceProvider>();

        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you really want to enter a new API key?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const Key('confirm-api-key-delete-button'),
              onPressed: () {
                Navigator.of(context).pop();
                searchServiceProvider
                    .resetStoredKey()
                    .then((_) => context.goToEnter());
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
