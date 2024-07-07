import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songapp2/main.dart';
import 'package:songapp2/models/song_model.dart';

class SongPlayingNotifier extends StateNotifier<Map<String, dynamic>?> {
  final AudioHandler _audioHandler;

  SongPlayingNotifier(this._audioHandler) : super(null);

  Future<void> playSong({required Song song, required List playlist}) async {
    try {
      state = {"playing": song, "playlist": playlist};
      await _audioHandler.customAction('setAudioSource', {'url': song.songUrl});
      await _audioHandler.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> stopSong() async {
    await _audioHandler.stop();
    state = null;
  }

  Future<void> pauseSong() async {
    await _audioHandler.pause();
  }

  Future<void> resumeSong() async {
    await _audioHandler.play();
  }
}

final songPlayingProvider =
    StateNotifierProvider<SongPlayingNotifier, Map<String, dynamic>?>((ref) {
  final audioHandler = ref.watch(audioHandlerProvider);
  return SongPlayingNotifier(audioHandler);
});

final audioHandlerProvider = Provider<AudioHandler>((ref) => audioHandler);
