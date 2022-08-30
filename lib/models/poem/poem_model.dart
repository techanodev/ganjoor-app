class PoemModel {
  final int id;
  final String title;
  final String fullTitle;
  final String plainText;

  PoemModel({
    required this.id,
    required this.title,
    required this.fullTitle,
    required this.plainText,
  });

  factory PoemModel.fromJson(Map<String, dynamic> json) {
    return PoemModel(
      id: json['id'],
      title: json['title'],
      fullTitle: json['fullTitle'],
      plainText: json['plainText'],
    );
  }
}
