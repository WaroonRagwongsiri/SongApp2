import 'package:flutter/material.dart';
import 'package:songapp2/auth.dart';
import 'package:songapp2/components/profilebar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          ProfileBar(userID: Auth().currentUser!.uid),
          ElevatedButton(
            onPressed: () => {Auth().signOut()},
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
