import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:songapp2/providers/song_playing_provider.dart';

class SongPlayer extends ConsumerWidget {
  const SongPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songPlaying = ref.watch(songPlayingProvider);
    final songPlayingNotifier = ref.read(songPlayingProvider.notifier);

    if (songPlaying == null) {
      return const SizedBox.shrink();
    }

    final bool isPause = songPlaying["isPause"] ?? false;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 70,
      child: InkWell(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                songPlaying['playing'].thumbnail,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    songPlaying['playing'].songName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(songPlaying['playing'].songArtist),
                ],
              ),
            ),
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
          ],
        ),
        onTap: () {
          context.pushNamed('songplaying',
              queryParameters: {'songId': songPlaying['playing'].id});
        },
      ),
    );
  }
}