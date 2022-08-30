import 'package:ganjoor/models/book/book_model.dart';
import 'package:ganjoor/services/ganjoor_service.dart';

class PoetCompleteModel {
  final int id;
  final int rootCatId;
  final String name;
  final String nickname;
  final String imageUrl;
  final String description;
  final String birthPlace;
  final String deathPlace;
  final int birthYear;
  final int deathYear;
  final List<BookModel> books;

  PoetCompleteModel({
    required this.id,
    required this.rootCatId,
    required this.name,
    required this.imageUrl,
    required this.nickname,
    required this.description,
    required this.birthPlace,
    required this.deathPlace,
    required this.birthYear,
    required this.deathYear,
    required this.books,
  });

  factory PoetCompleteModel.fromJson(Map<String, dynamic> json) {
    Map poetData = json['poet'];
    return PoetCompleteModel(
      id: poetData['id'],
      rootCatId: poetData['rootCatId'],
      name: poetData['name'],
      nickname: poetData['nickname'],
      imageUrl: GanjoorService.baseUrl + poetData['imageUrl'],
      description: poetData['description'],
      birthPlace: poetData['birthPlace'],
      deathPlace: poetData['deathPlace'],
      birthYear: poetData['birthYearInLHijri'],
      deathYear: poetData['deathYearInLHijri'],
      books: json['cat']['children']
          .map<BookModel>((e) => BookModel.fromJson(e))
          .toList(),
    );
  }
}
