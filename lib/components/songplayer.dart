import 'package:flutter/material.dart';
import 'package:songapp2/pages/song_playing_page.dart';

class SongPlayer extends StatefulWidget {
  final Map<String, dynamic> songData;
  const SongPlayer({super.key, required this.songData});

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: InkWell(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                widget.songData['thumbnail'],
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
                    widget.songData['songName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.songData['songArtist']),
                ],
              ),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
        onTap: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SongPlayingPage(
              songId : widget.songData['id'],
            );
          }))
        },
      ),
    );
  }
}
