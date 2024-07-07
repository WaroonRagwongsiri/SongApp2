import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songapp2/models/song_model.dart';

class SongPlayingNotifier extends StateNotifier<Song?> {
  SongPlayingNotifier() : super(null);

  void playSong(Song song) {
    state = song;
  }

  void stopSong() {
    state = null;
  }
}

final songPlayingProvider =
    StateNotifierProvider<SongPlayingNotifier, Song?>((ref) {
  return SongPlayingNotifier();
});
