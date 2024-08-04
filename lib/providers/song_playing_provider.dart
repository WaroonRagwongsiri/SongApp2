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
      // Handle Error
    }
  }

  Future<void> stopSong() async {
    await _audioHandler.stop();
    state = null;
  }

  Future<void> pauseSong() async {
    state = {...state!, "isPause": true};
    await _audioHandler.pause();
  }

  Future<void> resumeSong() async {
    state = {...state!, "isPause": false};
    await _audioHandler.play();
  }

  Stream<Duration> get positionStream {
    return _audioHandler.playbackState.map((state) {
      print("Position Stream: ${state.position}");
      return state.position;
    }).distinct();
  }

  Stream<Duration?> get durationStream {
    return _audioHandler.mediaItem.map((item) {
      print("Duration Stream: ${item?.duration}");
      return item?.duration;
    }).distinct();
  }

  Stream<Duration> get bufferedPositionStream {
    return _audioHandler.playbackState.map((state) {
      print("Buffered Position Stream: ${state.bufferedPosition}");
      return state.bufferedPosition;
    }).distinct();
  }

  Future<void> seek(Duration position) async {
    await _audioHandler.seek(position);
  }
}


final songPlayingProvider =
    StateNotifierProvider<SongPlayingNotifier, Map<String, dynamic>?>((ref) {
  final audioHandler = ref.watch(audioHandlerProvider);
  return SongPlayingNotifier(audioHandler);
});

final audioHandlerProvider = Provider<AudioHandler>((ref) => audioHandler);
