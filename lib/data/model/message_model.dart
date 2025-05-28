class MessageModel {
  final bool isPrompt;
  final String message;
  final DateTime time;

  MessageModel({
    required this.isPrompt,
    required this.message,
    required this.time,
  });
}
