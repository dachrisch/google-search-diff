import 'package:fimber/fimber.dart';
import 'package:localstore/localstore.dart';

class SearchResult {
  final String title;
  final String source;
  final String link;
  final String snippet;

  SearchResult(
      {required this.title,
      required this.source,
      required this.link,
      String? snippet})
      : snippet = (snippet == null || snippet.isEmpty) ? title : snippet;

  Map<String, dynamic> toJson() =>
      {'title': title, 'source': source, 'link': link, 'snippet': snippet};
}

class NoSearchResults extends SearchResults {
  NoSearchResults() : super(query: '', timestamp: DateTime(1970));

  @override
  count() {
    return 0;
  }

  @override
  Map<String, dynamic> toJson() {
    throw StateError("No Search Result - can't create json");
  }
}

class SearchResults {
  final String query;
  final DateTime timestamp;
  final List<SearchResult> results = [];

  SearchResults({required this.query, required this.timestamp});

  count() => results.length;

  Map<String, dynamic> toJson() => {
        'query': query,
        'timestamp': timestamp.toIso8601String(),
        'results': results.map((r) => r.toJson()).toList(),
      };
}

extension StorableSearchResults on SearchResults {
  Future save() async {
    final logger = FimberLog('store');
    final db = Localstore.instance;
    final id = db.collection('searches').doc().id;
    var json = toJson();
    logger.d('Storing $this with [$id]: $json');
    return db.collection('searches').doc(id).set(json);
  }
}
