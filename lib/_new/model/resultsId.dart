import 'package:google_search_diff/_new/model/uuidMixin.dart';
import 'package:uuid/uuid.dart';

class ResultsId with UuidMixin {
  ResultsId(String id) {
    initId(id);
  }

  static withUuid() => ResultsId(const Uuid().v4());
}
