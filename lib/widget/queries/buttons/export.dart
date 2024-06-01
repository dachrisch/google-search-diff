import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store_export.dart';
import 'package:google_search_diff/service/queries_store_share_service.dart';
import 'package:google_search_diff/widget/snackbar.dart';
import 'package:share_plus/share_plus.dart';

class ExportListTile extends StatefulWidget {
  const ExportListTile({super.key});

  @override
  State<StatefulWidget> createState() => _ExportListTileState();
}

class _ExportListTileState extends State<ExportListTile> {
  late QueriesStoreShareService exportService;

  @override
  void initState() {
    exportService = getIt<QueriesStoreShareService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: const Key('export-queries-button'),
        title: const Text('Export Queries to JSON'),
        onTap: () => _onExportQueries(context)
            .then((result) => context.showSnackbar(title: result))
            .then((_) => context.pop()),
        leading: const Icon(Icons.share_outlined));
  }

  Future<String> _onExportQueries(BuildContext context) async {
    QueriesStoreExport export = exportService.export();
    Future f;
    if (kIsWeb || kDebugMode) {
      f = FileSaver.instance.saveFile(
        name: export.fileName,
        bytes: export.bytes,
        ext: 'json',
        mimeType: MimeType.json,
      );
    } else {
      final box = context.findRenderObject() as RenderBox?;
      f = Share.shareXFiles(
        [
          XFile.fromData(
            export.bytes,
            name: export.fileName,
            mimeType: 'application/json',
          ),
        ],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }
    return f.then((_) =>
        'Exported ${export.queries.length} Queries with ${export.runs.length} Runs');
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }
}
