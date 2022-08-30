class PoemModel {
  final int id;
  final String title;
  final String excerpt;

  PoemModel({
    required this.id,
    required this.title,
    required this.excerpt,
  });

  factory PoemModel.fromJson(Map<String, dynamic> json) {
    return PoemModel(
      id: json['id'],
      title: json['title'],
      excerpt:
          json.containsKey('excerpt') ? json['excerpt'] : json['fullTitle'],
    );
  }
}
