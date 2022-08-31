class VersModel {
  final int id;
  final String text;

  VersModel({
    required this.id,
    required this.text,
  });

  factory VersModel.fromJson(Map<String, dynamic> json) {
    return VersModel(
      id: json['id'],
      text: json['text'],
    );
  }
}
