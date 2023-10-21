import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Clone extends StatefulWidget {
  const Clone({Key? key}) : super(key: key);

  @override
  State<Clone> createState() => CloneState();
}

class CloneState extends State<Clone> {
  final user = FirebaseAuth.instance.currentUser;
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
  final String chatName;

  const ChatScreen(this.chatName, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize any setup or listeners for your chat screen, if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chat_messages')
                  .where('chatName', isEqualTo: widget.chatName)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
          
                

                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  String text = message['text'];
                  String sender = message['sender'];
                  bool isSentMessage = sender == auth.currentUser?.uid;
                  messageWidgets.add(
                    ChatMess(text: text, isSentMessage: isSentMessage),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              }
              else{
                return const Scaffold(
                );
              }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String messageText = messageController.text;
                    if (messageText.isNotEmpty) {
                      sendMessage(messageText);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) {
    firestore.collection('chat_messages').add({
      'sender': auth.currentUser?.uid,
      'chatName': widget.chatName,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class ChatScreenBody extends StatelessWidget {
  final List<Map<String, dynamic>> chatMessages;

  const ChatScreenBody(this.chatMessages, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: chatMessages
          .map((message) => ChatMess(
                text: message['text'],
                isSentMessage: message['isSent'],
              ))
          .toList(),
    );
  }
}
class ChatMess extends StatelessWidget {
  final String text;
  final bool isSentMessage;

  ChatMess({Key? key, required this.text, required this.isSentMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentMessage ? Colors.blue : Colors.green, // Customize colors
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final Function(String) onSendMessage;

  ChatInputField({super.key, required this.onSendMessage});

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
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

