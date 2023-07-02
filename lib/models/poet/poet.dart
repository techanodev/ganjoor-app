import 'package:sheidaie/services/ganjoor_service.dart';

class PoetModel {
  final int id;
  final String name;
  final String nickname;
  final String imageUrl;

  PoetModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.nickname,
  });

  factory PoetModel.fromJson(Map<String, dynamic> json) {
    return PoetModel(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      imageUrl: GanjoorService.baseUrl + json['imageUrl'],
    );
  }
}
