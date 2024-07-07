import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:songapp2/services/song_service.dart';

class SongPlayingPage extends StatefulWidget {
  final String songId;
  const SongPlayingPage({super.key, required this.songId});

  @override
  State<SongPlayingPage> createState() => _SongPlayingPageState();
}

class _SongPlayingPageState extends State<SongPlayingPage> {
  Map<String, dynamic> songData = {};
  bool isLoading = true;

  Future<void> getSongData() async {
    try {
      Map<String, dynamic>? data = await SongService().getSongData(
          songRef:
              FirebaseFirestore.instance.collection("Song").doc(widget.songId));
      setState(() {
        songData = data;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getSongData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(songData['songName']),
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
              songData['thumbnail'],
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.scaleDown,
            ),
          ),
          ListTile(
            title: Text(
              songData['songName'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(songData['songArtist']),
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
