import 'package:flutter/material.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultCard extends StatelessWidget {
  final Result result;
  final IconData? iconData;

  const ResultCard({super.key, required this.result, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: iconData == null ? null : Icon(iconData),
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
        ));
  }
}
