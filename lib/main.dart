import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messen_clone/login.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  bool IsAuth=false;
  
  @override
  Widget build(BuildContext context) {
    if(IsAuth){
    return const MaterialApp(
      title: 'messenger',
      home: Clone(),
    );}
    else{
      return const MaterialApp(
        title: 'messenger',
        home: LoginPage(),
      );
    }
  }
}

class Clone extends StatefulWidget {
  const Clone({Key? key}) : super(key: key);

  @override
  State<Clone> createState() => CloneState();
}

class CloneState extends State<Clone> {
  int _currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chats', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const CircleAvatar(backgroundColor: Colors.grey,child: Icon(Icons.person)),
          ),
        ],
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu,color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
          drawer: Drawer(
        // Add the contents of your drawer here
        child: ListView(
          children: [
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle item 1 tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more items here
          ],
        ),
      ),
      body: body(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        onTap: (int index){
          setState(() {
            _currentindex=index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded),label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.people),label: 'People'),
        ],
      
      ),

    );
    }
    Widget body() {
  if (_currentindex == 0) {
    List<String> chatNames = ["Chat 1", "Chat 2", "Chat 3",];

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            color: Colors.grey[250],
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                filled: true,
                fillColor: Colors.grey[250],
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        
        for (String chatName in chatNames)
          ListTile(
            onTap:() {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChatScreen(chatName),
              ),
            );
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Center(
              child: Text(
                chatName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  } else {
    return const Center(
      child: Text('People here'),
    );
  }
}
}
class ChatScreen extends StatefulWidget {
  final String chatName; // You can pass the chat name or any necessary data here

  const ChatScreen(this.chatName);

  @override
    _ChatScreenState createState() => _ChatScreenState();

}
class _ChatScreenState extends State<ChatScreen> {
  List<String> chatMessages = ['Hello!', 'Hi there!']; // Initial chat messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
      ),
      body: ChatScreenBody(chatMessages),
      bottomSheet: ChatInputField(
        onSendMessage: (message) {
          // Handle sending the message and updating the chatMessages list
          setState(() {
            chatMessages.add(message);
          });
        },
      ),
    );
  }
}
class ChatScreenBody extends StatelessWidget {
  final List<String> chatMessages;

  ChatScreenBody(this.chatMessages);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: chatMessages
          .map((message) => ChatMess(text: message))
          .toList(),
    );
  }
}
class ChatMess extends StatelessWidget {
  final String text;
  const ChatMess({required this.text});

  @override
   Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight, // You can change this as needed
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
class ChatInputField extends StatelessWidget {
  final Function(String) onSendMessage;

  ChatInputField({required this.onSendMessage});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              String message = messageController.text;
              if (message.isNotEmpty) {
                // Send the message to the chat
                onSendMessage(message);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

