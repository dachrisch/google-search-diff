import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store_export.dart';
import 'package:google_search_diff/service/file_picker_service.dart';
import 'package:google_search_diff/service/queries_store_share_service.dart';

class ImportListTile extends StatefulWidget {
  const ImportListTile({super.key});

  @override
  State<StatefulWidget> createState() => _ImportListTileState();
}

class _ImportListTileState extends State<ImportListTile> {
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
        onTap: () => _onImportQueries(context),
        leading: const Icon(Icons.upload_outlined));
  }

  void _onImportQueries(BuildContext context) async {
    filePickerService.pickFilesJson(allowedExtensions: ['json']).then((json) =>
        json != null
            ? exportService.import(QueriesStoreExport.fromJson(json))
            : null);
  }
}
