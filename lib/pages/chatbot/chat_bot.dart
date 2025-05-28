import 'package:admin_hrm/data/model/message_model.dart';
import 'package:admin_hrm/service/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBotFloatingButton extends StatefulWidget {
  @override
  State<ChatBotFloatingButton> createState() => _ChatBotFloatingButtonState();
}

class _ChatBotFloatingButtonState extends State<ChatBotFloatingButton> {
  bool _showChat = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();

  final List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _sendInitialMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendInitialMessage() {
    const initialText =
        "Chào bạn! Tôi là chat bot của hệ thống Manager_HRM tôi có thể giúp gì bạn hôm nay? 🤖";
    setState(() {
      _messages.add(MessageModel(
        isPrompt: false,
        message: initialText,
        time: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userMessage = text.trim();

    setState(() {
      _messages.add(MessageModel(
        isPrompt: true,
        message: userMessage,
        time: DateTime.now(),
      ));
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final botReply = await _geminiService.chatWithGemini(userMessage);

      setState(() {
        _messages.add(MessageModel(
          isPrompt: false,
          message: botReply,
          time: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(MessageModel(
          isPrompt: false,
          message: "Đã có lỗi xảy ra khi kết nối đến AI. Vui lòng thử lại sau!",
          time: DateTime.now(),
        ));
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi gọi chatbot')),
        );
      }
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: _showChat ? 500 : 64,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_showChat)
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 500,
                  height: 400,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Chatbot hỗ trợ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _showChat = false),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, idx) {
                            final msg = _messages[idx];
                            final isUser = msg.isPrompt;
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.blue[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.message,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      DateFormat('hh:mm a').format(msg.time),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                  hintText: 'Nhập câu hỏi...'),
                              onSubmitted: _sendMessage,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: () => _sendMessage(_controller.text),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: FloatingActionButton(
                heroTag: 'chatbot',
                backgroundColor: Colors.grey,
                onPressed: () => setState(() => _showChat = !_showChat),
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
