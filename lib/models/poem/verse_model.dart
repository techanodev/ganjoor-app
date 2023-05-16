class VersModel {
  final int id;
  final int coupletIndex;
  final int vOrder;
  final String text;

  VersModel({
    required this.id,
    required this.coupletIndex,
    required this.vOrder,
    required this.text,
  });

  factory VersModel.fromJson(Map<String, dynamic> json) {
    return VersModel(
      id: json['id'],
      coupletIndex: json['coupletIndex'],
      vOrder: json['vOrder'],
      text: json['text'],
    );
  }
}
