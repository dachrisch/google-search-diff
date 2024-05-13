import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  final String title;
  final String source;
  final String link;
  final String? snippet;
  final String? favicon;

  Result(
      {required this.title,
      this.source = '',
      this.link = '',
      this.snippet,
      this.favicon});

  Map<String, dynamic> toJson() => _$ResultToJson(this);

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  @override
  bool operator ==(Object other) =>
      other is Result &&
      title == other.title &&
      source == other.source &&
      link == other.link;

  @override
  int get hashCode =>
      Object.hashAll([title.hashCode, source.hashCode, link.hashCode]);

  @override
  String toString() => 'Result(title: $title, source: $source, link: $link)';
}
