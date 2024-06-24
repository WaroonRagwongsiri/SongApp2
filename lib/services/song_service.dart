import 'package:cloud_firestore/cloud_firestore.dart';

class SongService {
  CollectionReference songRef = FirebaseFirestore.instance.collection("Songs");

  Future<List<DocumentReference>> getAllSong() async {
    List<DocumentReference> allSongRef = [];
    QuerySnapshot allSongSnapshot = await songRef.get();

    for (var doc in allSongSnapshot.docs) {
      allSongRef.add(doc.reference);
    }

    return allSongRef;
  }

  Future<Map<String, dynamic>> getSongData(
      {required DocumentReference songRef}) async {
    try {
      var songData = await songRef.get();

      if (!songData.exists) {
        return {};
      }
      return songData.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error fetching user data');
    }
  }
}
