import 'dart:io';

void cleanupBefore() {
  var directory = Directory('.search');
  if (directory.existsSync()) directory.deleteSync(recursive: true);
}
