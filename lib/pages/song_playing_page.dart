import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songapp2/models/song_model.dart';
import 'package:songapp2/providers/song_playing_provider.dart';
import 'package:songapp2/services/song_service.dart';

class SongPlayingPage extends ConsumerStatefulWidget {
  final String songId;
  const SongPlayingPage({super.key, required this.songId});

  @override
  ConsumerState<SongPlayingPage> createState() => _SongPlayingPageState();
}

class _SongPlayingPageState extends ConsumerState<SongPlayingPage> {
  bool isLoading = true;

  Future<void> getSongData() async {
    try {
      final Map<String, dynamic> songData = await SongService().getSongData(
          songRef: FirebaseFirestore.instance
              .collection("Songs")
              .doc(widget.songId));

      final currentPlaying = ref.read(songPlayingProvider);

      if (currentPlaying != null &&
          currentPlaying['playing'].id == widget.songId) {
        return;
      }

      if (currentPlaying != null &&
          currentPlaying['playing'].id != widget.songId) {
        ref.read(songPlayingProvider.notifier).stopSong();
      }

      ref.read(songPlayingProvider.notifier).playSong(
        song: Song(
          id: songData['id'],
          songName: songData['songName'],
          songArtist: songData['songArtist'],
          songUrl: songData['songUrl'],
          thumbnail: songData['thumbnail'],
        ),
        queue: [],
      );
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSongData();
  }

  @override
  Widget build(BuildContext context) {
    final songPlaying = ref.watch(songPlayingProvider);
    final songPlayingNotifier = ref.read(songPlayingProvider.notifier);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (songPlaying == null) {
      return const Scaffold(body: Center(child: Text('No song playing')));
    }

    final bool isPause = songPlaying["isPause"] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(songPlaying['playing'].songName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              songPlaying['playing'].thumbnail,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.scaleDown,
            ),
          ),
          ListTile(
            title: Text(
              songPlaying['playing'].songName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(songPlaying['playing'].songArtist),
            trailing: IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.add_circle_outline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamBuilder<Duration>(
              stream: songPlayingNotifier.positionStream,
              builder: (context, snapshot1) {
                final Duration position = snapshot1.data ?? Duration.zero;
                print("Position: $position");
                return StreamBuilder<Duration?>(
                  stream: songPlayingNotifier.durationStream,
                  builder: (context, snapshot2) {
                    final Duration? duration = snapshot2.data;
                    print("Duration: $duration");
                    return StreamBuilder<Duration>(
                      stream: songPlayingNotifier.bufferedPositionStream,
                      builder: (context, snapshot3) {
                        final Duration bufferedPosition =
                            snapshot3.data ?? Duration.zero;
                        print("Buffered Position: $bufferedPosition");
                        return SizedBox(
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProgressBar(
                              progress: position,
                              total: duration ?? Duration.zero,
                              buffered: bufferedPosition,
                              timeLabelPadding: -1,
                              timeLabelTextStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              onSeek: duration != null
                                  ? (duration) async {
                                      await songPlayingNotifier.seek(duration);
                                    }
                                  : null,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () => {}, icon: const Icon(Icons.shuffle)),
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.skip_previous)),
              IconButton(
                onPressed: () {
                  if (isPause) {
                    songPlayingNotifier.resumeSong();
                  } else {
                    songPlayingNotifier.pauseSong();
                  }
                },
                icon: Icon(isPause ? Icons.play_arrow : Icons.pause),
              ),
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.skip_next)),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.loop)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(child: SizedBox()),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.share)),
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.playlist_play)),
            ],
          ),
        ],
      ),
    );
  }
}
