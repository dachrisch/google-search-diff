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
}
