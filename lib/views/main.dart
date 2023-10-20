import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messen_clone/views/login.dart';
import 'package:messen_clone/views/messenger.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  bool isAuth=false;
  
  @override
  Widget build(BuildContext context) {
    if(isAuth){
    return const MaterialApp(
      title: 'messenger',
      home: Clone(),
    );}
    else{
      return const MaterialApp(
        title: 'messenger',
        home: LoginView(),
      );
    }
  }
}