import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:google_search_diff/theme.dart';
import 'package:google_search_diff/widget/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({super.key});

  @override
  Widget build(BuildContext context) => const EnterApiKeyPage();
}

class EnterApiKeyPage extends StatefulWidget {
  const EnterApiKeyPage({super.key});

  @override
  State<EnterApiKeyPage> createState() => _EnterApiKeyPageState();
}

class _EnterApiKeyPageState extends State<EnterApiKeyPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  late SearchServiceProvider searchServiceProvider;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    searchServiceProvider = context.read<SearchServiceProvider>();
  }

  Future<void> _validateAndNavigate(BuildContext context) async {
    String apiKey = _apiKeyController.text;
    await _isValidApiKey(apiKey).then((result) {
      if (result) {
        searchServiceProvider.useSerpService();
        context.showSnackbar(title: 'API-Key accepted.');
        context.go('/queries');
      } else {
        setState(() {
          _errorText = 'Invalid API key';
        });
      }
    });
  }

  void _tryAndNavigate() {
    searchServiceProvider.useTryService();
    context.go('/queries');
  }

  Future<bool> _isValidApiKey(String apiKey) {
    return searchServiceProvider.serpApiSearchService.apiKeyService
        .validateAndAccept(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            backgroundColor: MaterialTheme.lightScheme().primaryContainer,
            leading: Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
            automaticallyImplyLeading: false,
            title: Text(
              'SearchFlux - Welcome',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'An API key from ',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(
                                text: 'serpapi.com',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrl(
                                      Uri.parse('https://serpapi.com')),
                              ),
                              const TextSpan(
                                text:
                                    ' is needed to continue. Please enter your API key below.',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  key: const Key('api-key-text-field'),
                  controller: _apiKeyController,
                  decoration: InputDecoration(
                    labelText: 'API Key',
                    errorText: _errorText,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AsyncButtonBuilder(
                        child: const Icon(Icons.login),
                        onPressed: () => _validateAndNavigate(context),
                        builder: (context, child, callback, buttonState) {
                          return AnimatedSwitcher(
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.fastOutSlowIn,
                            duration: Durations.extralong4,
                            transitionBuilder: (child, animation) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(10, 0),
                                      end: const Offset(0, 0))
                                  .animate(animation),
                              child: child,
                            ),
                            child: ElevatedButton.icon(
                              key: const Key('login-with-key-button'),
                              onPressed: callback,
                              label: const Text('Login'),
                              icon: child,
                            ),
                          );
                        }),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      key: const Key('try-it-button'),
                      onPressed: _tryAndNavigate,
                      child: const Text('Try it'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
