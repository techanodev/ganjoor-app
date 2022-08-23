class PoetModel {
  final int id;
  final int rootCatId;
  final String name;
  final String nickname;
  final String description;
  final String fullUrl;
  final String imageUrl;

  PoetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.fullUrl,
    required this.imageUrl,
    required this.rootCatId,
    required this.nickname,
  });

  factory PoetModel.fromJson(Map<String, dynamic> json) {
    return PoetModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      fullUrl: json['fullUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      rootCatId: json['rootCatId'] as int,
      description: json['email'] as String,
    );
  }
}
