import 'package:chat_app/constants.dart';
import 'package:chat_app/functions/function_time.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageFriendsWidgetWidget extends StatelessWidget {
  final Message message;

  const MessageFriendsWidgetWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
            color: kThirdColor,
          ),
          child: Column(
            children: [
              Text(
                message.message,
                style: GoogleFonts.glory(
                  fontSize: 18,
                  color: kSecondColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                formatTime(message.dateTime),
                style: GoogleFonts.glory(
                  fontSize: 12,
                  color: kSecondColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
