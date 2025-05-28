import 'package:flutter/material.dart';

class UserPrompt extends StatelessWidget {
  const UserPrompt({
    super.key,
    required this.message,
    required this.isPrompt,
    required this.date,
  });

  final String message;
  final bool isPrompt;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ).copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 15 : 80),
      decoration: BoxDecoration(
        color: isPrompt ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isPrompt ? Radius.circular(20) : Radius.circular(0),
          bottomRight: isPrompt ? Radius.zero : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
