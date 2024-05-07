import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class ResultModel {
  final String title;
  final String source;
  final String link;
  final String snippet;

  ResultModel(
      {required this.title,
      this.source = '',
      this.link = '',
      this.snippet = ''});

  Map<String, dynamic> toJson() => _$ResultModelToJson(this);

  factory ResultModel.fromJson(Map<String, dynamic> json) =>
      _$ResultModelFromJson(json);

  @override
  bool operator ==(Object other) =>
      other is ResultModel &&
      title == other.title &&
      source == other.source &&
      link == other.link;

  @override
  int get hashCode =>
      Object.hashAll([title.hashCode, source.hashCode, link.hashCode]);

  @override
  String toString() => 'Result(title: $title, source: $source, link: $link)';
}
