import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messen_clone/firebase_options.dart';
import 'package:messen_clone/views/login.dart';
import 'package:messen_clone/views/messenger.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HomePage());
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'messenger',
      home: Home(),
    );
  }
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
      
      
       builder: (context,snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if(user!=null){
              return const Clone();
            }
            else{
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
       }
       );
  }
}
    
    
    
    
    
    
     