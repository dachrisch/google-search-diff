import 'package:flutter/material.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultCard extends StatelessWidget {
  final Result result;
  final Icon? icon;
  final bool visitable;

  const ResultCard(
      {super.key, required this.result, this.icon, this.visitable = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: InkWell(
          onTap: visitable ? () => context.gotToResult(result) : null,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: icon,
                  title: Text(result.title),
                  subtitle: Text(result.source),
                  trailing: result.favicon == null
                      ? null
                      : Image.network(result.favicon!),
                ),
                Row(
                  children: result.snippet == null
                      ? []
                      : <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(result.snippet!)))
                        ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Visit'),
                      onPressed: () => launchUrl(Uri.parse(result.link)),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
