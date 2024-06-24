class Song {
  final String songName;
  final String songArtist;
  final String songUrl;
  final String thumbnail;

  Song({
    required this.songName,
    required this.songArtist,
    required this.songUrl,
    required this.thumbnail,
  });

  Map<String, dynamic> toMap() {
    return {
      "songName": songName,
      "songArtist": songArtist,
      "songUrl": songUrl,
      "thumbnail": thumbnail,
    };
  }
}
