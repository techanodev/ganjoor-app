class PoetModel {
  final int id;
  final String name;
  final String nickname;
  final String description;
  final String fullUrl;
  final String imageUrl;
  final int rootCatId;

  PoetModel(this.id, this.name, this.description, this.fullUrl, this.imageUrl,
      this.rootCatId, this.nickname);

  PoetModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        nickname = json['nickname'],
        fullUrl = json['fullUrl'],
        imageUrl = json['imageUrl'],
        rootCatId = json['rootCatId'],
        description = json['email'];
}
