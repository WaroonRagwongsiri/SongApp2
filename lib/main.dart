import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songapp2/auth.dart';
import 'package:songapp2/pages/home_page.dart';
import 'package:songapp2/pages/login_register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(routes: [
      ShellRoute(
        routes: [
          GoRoute(
            path: "/",
            name: "home",
            builder: (context, state) => const HomePage(),
          ),
        ],builder: (context, state, child) => const Placeholder(),
      ),
    ]);

    return StreamBuilder(stream: Auth().authStateChange, builder: (context,snapshot){
      if(snapshot.hasData){
        return MaterialApp.router(routerConfig: _router,theme: ThemeData.dark(),);
      }
      return const LoginRegisterPage();
    });
  }
}
