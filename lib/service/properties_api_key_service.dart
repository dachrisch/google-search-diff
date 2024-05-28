import 'package:google_search_diff/model/api_key.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class PropertiesApiKeyService {
  final SharedPreferences preferences;
  final String preferencesKey = 'api-key';

  PropertiesApiKeyService({required this.preferences});

  @factoryMethod
  @preResolve
  static Future<PropertiesApiKeyService> fromProperties() =>
      SharedPreferences.getInstance()
          .then((prefs) => PropertiesApiKeyService(preferences: prefs));

  Future<bool> save(ApiKey apiKey) =>
      preferences.setString(preferencesKey, apiKey.key);

  ApiKey fetch() => preferences.containsKey(preferencesKey)
      ? ApiKey(key: preferences.getString(preferencesKey)!)
      : EmptyApiKey();
}
