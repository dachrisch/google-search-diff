import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('Google Search Provider', () async {


    var apiKey = const String.fromEnvironment('GOOGLE_API_KEY');

    final sr = SerapiRetriever(apiKey: apiKey);

    expect((await sr.query('query')).length, 100);
  });
}
