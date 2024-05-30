import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class FilePickerService {
  Future<Map<String, dynamic>?> pickFilesJson(
          {required List<String> allowedExtensions}) =>
      FilePicker.platform
          .pickFiles(
              type: FileType.custom, allowedExtensions: allowedExtensions)
          .then((result) => result?.xFiles.single
              .readAsString()
              .then((String jsonString) => jsonDecode(jsonString)));
}
