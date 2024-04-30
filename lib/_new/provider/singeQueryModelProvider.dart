import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/widget/singleQueryCard.dart';
import 'package:provider/provider.dart';

class SingleQueryModelProvider extends StatelessWidget {
  final SearchQueryModel searchQuery;

  const SingleQueryModelProvider({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: searchQuery, child: SingleQueryCard());
  }
}
