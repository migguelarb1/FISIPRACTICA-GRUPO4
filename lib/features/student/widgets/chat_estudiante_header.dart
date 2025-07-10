import 'package:flutter/material.dart';
import 'package:flutter_app/features/student/screens/chat/chat_estudiante_screen.dart';

class ChatEstudianteHeader extends StatefulWidget {
  const ChatEstudianteHeader(
      {super.key,
      this.recruiterAvatar,
      required this.recruiterName,
      required this.connectionStatus});
  final String? recruiterAvatar;
  final String recruiterName;
  final ConnectionStatus connectionStatus;

  @override
  State<ChatEstudianteHeader> createState() => _ChatEstudianteHeaderState();
}

class _ChatEstudianteHeaderState extends State<ChatEstudianteHeader> {
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
            backgroundImage: widget.recruiterAvatar != null
                ? NetworkImage(widget.recruiterAvatar!)
                : const AssetImage('assets/user_icon.png') as ImageProvider,
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
                  widget.recruiterName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.connectionStatus == ConnectionStatus.connected
                      ? 'En línea'
                      : 'Desconectado',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
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
