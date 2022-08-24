import '../../services/ganjoor_service.dart';

class PoetModel {
  final int id;
  final int rootCatId;
  final String name;
  final String nickname;
  final String fullUrl;
  final String imageUrl;

  PoetModel({
    required this.id,
    required this.name,
    required this.fullUrl,
    required this.imageUrl,
    required this.rootCatId,
    required this.nickname,
  });

  factory PoetModel.fromJson(Map<String, dynamic> json) {
    return PoetModel(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      fullUrl: json['fullUrl'],
      imageUrl: GanjoorService.baseUrl + json['imageUrl'],
      rootCatId: json['rootCatId'] as int,
    );
  }
}
