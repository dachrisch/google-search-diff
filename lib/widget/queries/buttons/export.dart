import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store_export.dart';
import 'package:google_search_diff/service/queries_store_export_service.dart';
import 'package:share_plus/share_plus.dart';

class ExportButton extends StatefulWidget {
  const ExportButton({super.key});

  @override
  State<StatefulWidget> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  late QueriesStoreExportService exportService;

  @override
  void initState() {
    exportService = getIt<QueriesStoreExportService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('export-queries-button'),
      tooltip: 'Export queries',
      onPressed: () => _onExportQueries(context),
      icon: const Icon(Icons.share_outlined),
    );
  }

  void _onExportQueries(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    QueriesStoreExport export = exportService.export();

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: export.fileName,
        bytes: export.bytes,
        ext: 'json',
        mimeType: MimeType.json,
      );
    } else {
      final shareResult = await Share.shareXFiles(
        [
          XFile.fromData(
            export.bytes,
            name: export.fileName,
            mimeType: 'application/json',
          ),
        ],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
    }
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
