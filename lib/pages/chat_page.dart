import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String recieverID;
  final String recieverEmail;

  const ChatPage({
    super.key,
    required this.recieverID,
    required this.recieverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _msgController = TextEditingController();

  // caht and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // for text field focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up
        // then the amount of remaining space will be calculated,
        // then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // wait a bit for list view to be built, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _msgController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async {
    // if there's sth in the text field
    if (_msgController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(widget.recieverID, _msgController.text);

      // clear text controller
      _msgController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recieverEmail,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    DateTime?
        previousDate; // Move `previousDate` to the scope of `_buildMessageList`

    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        // check for error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        // loading ..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading . . .');
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) {
            final widget = _buildMessageItem(doc, previousDate);

            // Update `previousDate` after rendering each message
            previousDate = DateTime.fromMillisecondsSinceEpoch(
              doc['timestamp'].seconds * 1000 +
                  doc['timestamp'].nanoseconds ~/ 1000000,
            );

            return widget;
          }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, DateTime? previousDate) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      data['timestamp'].seconds * 1000 +
          data['timestamp'].nanoseconds ~/ 1000000,
    );

    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    // Check if date separator is needed
    bool showDateSeparator = (previousDate == null) ||
        previousDate.day != dateTime.day ||
        previousDate.month != dateTime.month ||
        previousDate.year != dateTime.year;

    // Determine if the sender is the current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // Align message based on sender
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showDateSeparator) // Display date separator if needed
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        Container(
          alignment: alignment,
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ChatBubble(
                  message: data['message'], isCurrentUser: isCurrentUser),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              hintText: 'Type a message ...',
              masked: false,
              controller: _msgController,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(
              right: 25,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
