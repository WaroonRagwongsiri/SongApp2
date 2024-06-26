import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:songapp2/auth.dart';
import 'package:songapp2/components/navigation_shell.dart';
import 'package:songapp2/pages/home_page.dart';
import 'package:songapp2/pages/library_page.dart';
import 'package:songapp2/pages/login_register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:songapp2/pages/profile_page.dart';
import 'package:songapp2/pages/search_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(routes: [
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
    ]);

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
