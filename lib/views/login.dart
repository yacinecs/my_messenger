import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email=TextEditingController();
    _password=TextEditingController();

    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
      ),
      body: Column(
          children: [
          TextField(
            decoration: const InputDecoration(hintText: 'User'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Pass'),
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async{
            final email=_email.text;
            final password = _password.text;
            try{
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
             
            }
            on FirebaseAuthException catch (e){
                if(e.code == 'user-not-found'){
                 
                }
                else if (e.code == 'wrong-password'){
                 
                }
            }
            }, child: const Text('Login')
          )
        ],
        ),
    );
 }}