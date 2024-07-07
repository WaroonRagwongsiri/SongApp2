import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songapp2/components/songplayer.dart';

class NavigationShell extends StatefulWidget {
  final Widget child;

  const NavigationShell({super.key, required this.child});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  Map<String, dynamic> testSong = {
    "id": "O0FHNTNvduu5eC1A2usr",
    "songName": "Blue Moon Blue Ocean",
    "songArtist": "Interlunium · Caitlin Myers",
    "songUrl":
        "https://firebasestorage.googleapis.com/v0/b/songapp2-45dcc.appspot.com/o/songs%2FBlue%20Moon%20Blue%20Ocean.mp3?alt=media&token=b3447d11-c45b-4f84-ac6d-0125e57f0f1e",
    "thumbnail": "https://f4.bcbits.com/img/a3887114479_65",
  };

  void onTap(index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case (0):
        GoRouter.of(context).go('/');
        break;
      case (1):
        GoRouter.of(context).go('/search');
        break;
      case (2):
        GoRouter.of(context).go('/library');
        break;
      case (3):
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomSheet: const SongPlayer(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Colors.transparent],
          ),
        ),
        child: BottomNavigationBar(
          //Style
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: true,
          //
          currentIndex: _currentIndex,
          onTap: (value) => onTap(value),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.saved_search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              activeIcon: Icon(Icons.library_music),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
