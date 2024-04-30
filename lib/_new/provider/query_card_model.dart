import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/widget/query_card.dart';
import 'package:provider/provider.dart';

class QueryCardQueryModelProvider extends StatelessWidget {
  final QueryModel searchQuery;

  const QueryCardQueryModelProvider({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: searchQuery, child: SingleQueryCard());
  }
}
