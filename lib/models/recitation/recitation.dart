class RecitationModel {
  final int id;
  final int poemId;
  final String audioTitle;
  final String artist;
  final String mp3Url;

  RecitationModel({
    required this.id,
    required this.poemId,
    required this.audioTitle,
    required this.artist,
    required this.mp3Url,
  });

  factory RecitationModel.fromJson(Map<String, dynamic> json) {
    return RecitationModel(
      id: json['id'],
      poemId: json['poemId'],
      audioTitle: json['audioTitle'],
      artist: json['audioArtist'],
      mp3Url: json['mp3Url'],
    );
  }
}
