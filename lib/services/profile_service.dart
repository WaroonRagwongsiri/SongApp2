import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  CollectionReference userRef = FirebaseFirestore.instance.collection("Users");

  Future<Map<String, dynamic>> getUserData({required String userId}) async {
    try {
      DocumentSnapshot userSnapshot = await userRef.doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
