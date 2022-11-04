class VersModel {
  final int id;
  final String text;
  final int coupletIndex;

  VersModel({
    required this.id,
    required this.text,
    required this.coupletIndex,
  });

  factory VersModel.fromJson(Map<String, dynamic> json) {
    return VersModel(
      id: json['id'],
      text: json['text'],
      coupletIndex: json['coupletIndex'],
    );
  }
}
