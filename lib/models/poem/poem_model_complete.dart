import 'package:ganjoor/models/poem/verse_model.dart';

class PoemCompleteModel {
  final int id;
  final String title;
  final String excerpt;
  final String source;
  final String rhythm;
  final List<VersModel> vers;

  PoemCompleteModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.source,
    required this.rhythm,
    required this.vers,
  });

  factory PoemCompleteModel.fromJson(Map<String, dynamic> json) {
    return PoemCompleteModel(
      id: json['id'],
      title: json['title'],
      excerpt:
          json.containsKey('excerpt') ? json['excerpt'] : json['fullTitle'],
      source: json['sourceName'],
      rhythm: json['sections'][0]['ganjoorMetre']['rhythm'],
      vers:
          json['verses'].map<VersModel>((e) => VersModel.fromJson(e)).toList(),
    );
  }
}
