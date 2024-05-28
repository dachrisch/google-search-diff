import 'package:google_search_diff/logger.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class ApiKeyService {
  final String endpoint = 'serpapi.com';
  final Logger l = getLogger('api-key');
  String key = '';

  ApiKeyService();

  Future<bool> validateAndAccept(String key) async {
    var uri = Uri.https(
        endpoint, '/search', {'output': 'json', 'api_key': key, 'q': 'test'});
    l.d(uri);
    return http
        .get(uri)
        .then((response) => response.statusCode == 200)
        .then((result) {
      this.key = key;
      return result;
    }).onError(
      (error, stackTrace) => false,
    );
  }
}
