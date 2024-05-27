import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/theme.dart';
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
  String? _errorText;

  void _validateAndNavigate() {
    String apiKey = _apiKeyController.text;

    if (_isValidApiKey(apiKey)) {
      context.go('/queries');
    } else {
      setState(() {
        _errorText = 'Invalid API key';
      });
    }
  }

  void _tryAndNavigate() {
    getIt.registerSingleton<SearchService>(LoremIpsumSearchService());
    context.go('/queries');
  }

  bool _isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty;
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
                  controller: _apiKeyController,
                  decoration: InputDecoration(
                    labelText: 'API Key',
                    errorText: _errorText,
                  ),
                  obscureText: true, // If you want to obscure the API key
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _validateAndNavigate,
                      child: const Text('Submit'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
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
