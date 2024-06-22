import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:songapp2/auth.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  int _currentIndex = 0;
  String errorMessage = "";

  Future<void> signIn({required String email, required String password}) async {
    try {
      await Auth().signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      await Auth()
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(Auth().currentUser!.uid)
          .set({
        "username": username,
        "email": email,
        "uid": Auth().currentUser!.uid,
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildLoginScreen(context),
          _buildRegisterScreen(context),
        ],
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Icon(Icons.logo_dev),
            const Text("SongApp"),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                signIn(
                    email: emailController.text,
                    password: passwordController.text)
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text(
                'Sign In',
              ),
            ),
            const SizedBox(height: 20),
            Text(errorMessage),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterScreen(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordCheckController =
        TextEditingController();
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Icon(Icons.logo_dev),
            const Text("SongApp"),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextFormField(
              controller: passwordCheckController,
              decoration: const InputDecoration(labelText: "Confirmm Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(passwordCheckController.text != passwordController.text){
                  return;
                }
                signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    username: usernameController.text);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text(
                'Sign Up',
              ),
            ),
            const SizedBox(height: 20),
            Text(errorMessage),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
