import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:songapp2/providers/song_playing_provider.dart';

class SongPlayer extends ConsumerWidget {
  const SongPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(songPlayingProvider);

    if (song == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: InkWell(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                song.thumbnail,
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
                    song.songName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(song.songArtist),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
        onTap: () => {
          context.pushNamed('songplaying',
                  queryParameters: {'songId': song.id})
        },
      ),
    );
  }
}