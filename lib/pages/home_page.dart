import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:songapp2/components/songtile.dart';
import 'package:songapp2/services/song_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: SongService().getAllSong(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text("Error occur");
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No song available");
              }

              List<DocumentReference> listSongRef = snapshot.data!;

              return Expanded(
                child: ListView.builder(
                    itemCount: listSongRef.length,
                    itemBuilder: (context, index) {
                      return SongTile(songRef: listSongRef[index]);
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
