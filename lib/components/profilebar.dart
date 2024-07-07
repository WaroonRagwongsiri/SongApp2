import 'package:flutter/material.dart';
import 'package:songapp2/services/profile_service.dart';

class ProfileBar extends StatelessWidget {
  final String userID;
  const ProfileBar({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ProfileService().getUserData(userId: userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No profile available'));
          }
          Map<String, dynamic> userData = snapshot.data!;

          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.orange, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            height: MediaQuery.of(context).size.height * 1 / 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Image.network(
                      userData["profilePic"],
                      height: MediaQuery.of(context).size.height * 1 / 8,
                      width: MediaQuery.of(context).size.height * 1 / 8,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Text(userData["username"],style: const TextStyle(fontSize: 36),),
                ],
              ),
            ),
          );
        });
  }
}
