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
      
      final currentPlaying = ref.watch(songPlayingProvider);

      if(currentPlaying?['playing'].id == widget.songId){
        return;
      }

      if(currentPlaying != null && currentPlaying['playing'].id != widget.songId){
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
      return const Scaffold(body: Center(child: Text('Song not found')));
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () => {}, icon: const Icon(Icons.shuffle)),
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.skip_previous)),
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.play_arrow)),
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
