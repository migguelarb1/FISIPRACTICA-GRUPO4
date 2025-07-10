import 'package:flutter/material.dart';
import 'package:flutter_app/features/student/screens/chat/chat_bot_screen.dart';

class ChatBotHeader extends StatefulWidget {
  const ChatBotHeader(
      {super.key, required this.company, required this.connectionStatus});
  final String company;
  final ConnectionStatus connectionStatus;

  @override
  State<ChatBotHeader> createState() => _ChatBotHeaderState();
}

class _ChatBotHeaderState extends State<ChatBotHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
      elevation: 0,
      leadingWidth: 100,
      toolbarHeight: 60,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CircleAvatar(
            backgroundImage:
                AssetImage('assets/${widget.company.toLowerCase()}.png'),
          ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.company,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Asistente Virtual',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            widget.connectionStatus == ConnectionStatus.connected
                ? Icons.circle
                : Icons.circle_outlined,
            color: widget.connectionStatus == ConnectionStatus.connected
                ? Colors.green
                : Colors.grey,
            size: 12,
          ),
        ],
      ),
    );
  }
}
