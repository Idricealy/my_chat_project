import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
          color: Colors.blue
      ),
      child: Text(
        widget.message,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
