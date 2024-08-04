import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:songapp2/audio_player_handler.dart';
import 'package:songapp2/auth.dart';
import 'package:songapp2/components/navigation_shell.dart';
import 'package:songapp2/pages/home_page.dart';
import 'package:songapp2/pages/library_page.dart';
import 'package:songapp2/pages/login_register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:songapp2/pages/profile_page.dart';
import 'package:songapp2/pages/search_page.dart';
import 'package:songapp2/pages/song_playing_page.dart';
import 'firebase_options.dart';

late AudioHandler audioHandler;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.waroon.songapp.channel.audio',
      //com.mycompany.myapp.channel.audio
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: "/",
              name: "home",
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: "/search",
              name: "search",
              builder: (context, state) => const SearchPage(),
            ),
            GoRoute(
              path: "/library",
              name: "library",
              builder: (context, state) => const LibraryPage(),
            ),
            GoRoute(
              path: "/profile",
              name: "profile",
              builder: (context, state) => const ProfilePage(),
            ),
          ],
          builder: (context, state, child) => NavigationShell(child: child),
        ),
        GoRoute(
          path: "/songplaying",
          name: "songplaying",
          builder: (context, state) {
            final songId = state.uri.queryParameters['songId'];
            if (songId == null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Error"),
                ),
                body: const Center(
                  child: Text("No song ID provided."),
                ),
              );
            }
            return SongPlayingPage(songId: songId);
          },
        ),
      ],
    );

    return StreamBuilder(
        stream: Auth().authStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp.router(
              routerConfig: router,
              theme: ThemeData.dark(),
            );
          }
          return MaterialApp(
            home: const LoginPage(),
            theme: ThemeData.dark(),
          );
        });
  }
}
