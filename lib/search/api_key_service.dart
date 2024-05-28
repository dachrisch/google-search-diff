import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/api_key.dart';
import 'package:google_search_diff/service/properties_api_key_service.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class ApiKeyService {
  final String endpoint = 'serpapi.com';
  final Logger l = getLogger('api-key');
  final PropertiesApiKeyService propertiesApiKeyService;

  ApiKeyService({required this.propertiesApiKeyService});

  Future<bool> validateStoredKey() => validateKey(apiKey.key);

  Future<bool> validateAndAccept(String key) async {
    return validateKey(key).then((result) =>
        propertiesApiKeyService.save(ApiKey(key: key)).then((_) => result));
  }

  Future<bool> validateKey(String key) {
    if (key.isEmpty || key.length != 64) {
      return Future.value(false);
    }
    var uri = Uri.https(endpoint, '/account', {'api_key': key});
    l.d('validating api key using: $uri');
    return http.get(uri).then((response) => response.statusCode == 200).onError(
          (error, stackTrace) => false,
        );
  }

  ApiKey get apiKey => propertiesApiKeyService.fetch();

  Future<bool> clearKey() => propertiesApiKeyService.clear();
}
