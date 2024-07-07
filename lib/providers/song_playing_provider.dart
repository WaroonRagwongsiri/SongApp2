import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songapp2/models/song_model.dart';

class SongPlayingNotifier extends StateNotifier<Map<String, dynamic>?> {
  SongPlayingNotifier() : super(null);

  void playSong({required Song song, required List playlist}) {
    state = {"playing": song, "playlist": playlist};
  }

  void stopSong() {
    state = null;
  }
}

final songPlayingProvider =
    StateNotifierProvider<SongPlayingNotifier, Map<String, dynamic>?>((ref) {
  return SongPlayingNotifier();
});
