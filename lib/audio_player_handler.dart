import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  Timer? _positionTimer;

  AudioPlayerHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    _startPositionTimer();
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: _player.position,
      ));
    });
  }

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
    ));
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'setAudioSource' &&
        extras != null &&
        extras.containsKey('url')) {
      try {
        await _player.setUrl(extras['url']);
        final duration = _player.duration;
        print("Audio source set successfully. Duration: $duration");
        await updateMedia(extras['url'], duration);
      } catch (e) {
        print("Error setting audio source: $e");
      }
    }
  }

  Future<void> updateMedia(String url, Duration? duration) async {
    mediaItem.add(MediaItem(
      id: url,
      album: '',
      title: '',
      artist: '',
      duration: duration,
    ));
  }

  @override
  Future<void> play() async {
    await _player.play();
    _startPositionTimer();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _positionTimer?.cancel();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _positionTimer?.cancel();
  }

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
