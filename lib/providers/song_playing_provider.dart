import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songapp2/main.dart';
import 'package:songapp2/models/song_model.dart';

class SongPlayingNotifier extends StateNotifier<Map<String, dynamic>?> {
  final AudioHandler _audioHandler;

  SongPlayingNotifier(this._audioHandler) : super(null);

  Future<void> playSong({required Song song, required List queue}) async {
    try {
      state = {
        "playing": song,
        "queue": queue,
        "isPause": false,
      };
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
    state = {...state!, "isPause": true};
    await _audioHandler.pause();
    print(state);
  }

  Future<void> resumeSong() async {
    state = {...state!, "isPause": false};
    await _audioHandler.play();
    print(state);
  }
}

final songPlayingProvider =
    StateNotifierProvider<SongPlayingNotifier, Map<String, dynamic>?>((ref) {
  final audioHandler = ref.watch(audioHandlerProvider);
  return SongPlayingNotifier(audioHandler);
});

final audioHandlerProvider = Provider<AudioHandler>((ref) => audioHandler);
