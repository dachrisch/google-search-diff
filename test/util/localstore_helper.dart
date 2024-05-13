import 'dart:io';

void cleanupBefore(List<String> dirs) {
  for (String dir in dirs) {
    var directory = Directory(dir);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  }
}
