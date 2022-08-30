class BookModel {
  final int id;
  final String title;

  BookModel({
    required this.id,
    required this.title,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
