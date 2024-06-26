import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class SearchServiceProvider extends ChangeNotifier {
  final LoremIpsumSearchService trySearchService;
  final SerpApiSearchService serpApiSearchService;
  final Logger l = getLogger('search-provider');
  SearchService usedService;

  SearchServiceProvider({
    required this.trySearchService,
    required this.serpApiSearchService,
  }) : usedService = trySearchService;

  SearchService get useService {
    l.d('Using $usedService for search');
    return usedService;
  }

  void useTryService() {
    usedService = trySearchService;
    notifyListeners();
  }

  void useSerpService() {
    usedService = serpApiSearchService;
    notifyListeners();
  }

  bool get isTrying => usedService == trySearchService;

  Future<void> resetStoredKey() =>
      serpApiSearchService.apiKeyService.clearKey();

  Future<bool> validateAndAccept(String key) =>
      serpApiSearchService.apiKeyService.validateAndAccept(key);

  Future<bool> validateStoredKey() =>
      serpApiSearchService.apiKeyService.validateStoredKey();
}
