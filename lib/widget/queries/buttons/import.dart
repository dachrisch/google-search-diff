import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/service/file_picker_service.dart';
import 'package:google_search_diff/service/queries_store_share_service.dart';

class ImportListTile extends StatefulWidget {
  const ImportListTile({super.key});

  @override
  State<StatefulWidget> createState() => _ImportListTileState();
}

class _ImportListTileState extends State<ImportListTile>
    with TickerProviderStateMixin {
  late QueriesStoreShareService exportService;

  late FilePickerService filePickerService;

  @override
  void initState() {
    exportService = getIt<QueriesStoreShareService>();
    filePickerService = getIt<FilePickerService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: const Key('import-queries-button'),
        title: const Text('Import Queries from JSON'),
        onTap: () =>
            _onImportQueries(context).then((_) => Navigator.of(context).pop()),
        leading: const Icon(Icons.upload_outlined));
  }

  Future<void> _onImportQueries(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: FutureBuilder(
                future: filePickerService.pickFilesJson(allowedExtensions: [
                  'json'
                ]).then((json) => exportService.importFrom(json)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(height: 20),
                        const Text("Import completed successfully."),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  } else {
                    return const Row(
                      children: [
                        CircularProgressIndicator(
                          semanticsLabel: 'Importing queries...',
                        ),
                        SizedBox(width: 20),
                        Text("Importing..."),
                      ],
                    );
                  }
                })));
  }
}
