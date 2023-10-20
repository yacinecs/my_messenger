import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

Future<void> _signInWithEmailAndPassword(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Authentication successful, navigate to the main app (Clone).
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Clone()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      // Handle user not found error
    } else if (e.code == 'wrong-password') {
      // Handle wrong password error
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Replace these placeholders with the actual values entered by the user.
                final username = "user@example.com";
                final password = "userpassword";

                _signInWithEmailAndPassword(username, password,context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
