import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:songapp2/services/song_service.dart';

class SongTile extends StatelessWidget {
  final DocumentReference songRef;
  const SongTile({super.key, required this.songRef});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SongService().getSongData(songRef: songRef),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          Map<String,dynamic> songData = snapshot.data!;

          return ListTile(
            leading: Image.network(songData["thumbnail"]),
            title: Text(songData["songName"]),
            subtitle: Text(songData["songArtist"]),
            onTap: ()=>{},
          );
        });
  }
}
