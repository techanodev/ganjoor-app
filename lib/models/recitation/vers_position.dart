class VersPositionModel {
  final int id;
  final int position;

  VersPositionModel({
    required this.id,
    required this.position,
  });

  factory VersPositionModel.fromJson(Map<String, dynamic> json) {
    return VersPositionModel(
      id: json['VerseOrder'],
      position: json['AudioMiliseconds'],
    );
  }
}
