import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/message_model.dart';
import '../widgets/message_friends_widget.dart';
import '../widgets/user_pic_online.dart';

class ChatPage extends StatefulWidget {
  final String email;

  const ChatPage({super.key, required this.email});

  @override
  State<ChatPage> createState() => _ChatPageState(email);
}

class _ChatPageState extends State<ChatPage> {
  bool filledSelected = false;
  TextEditingController textEditingController = TextEditingController();
  final _controller = ScrollController();
  final String email;

  _ChatPageState(this.email);

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messageList = [];
            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              if (data.containsKey('message') && data['message'].isNotEmpty) {
                messageList.add(Message.fromJson(data));
              }
            }
            return Scaffold(
              backgroundColor: kPrimaryColor,
              appBar: AppBar(
                backgroundColor: kThirdColor,
                elevation: 0,
                title: Row(
                  children: [
                    IconButton(
                      color: kSecondColor,
                      onPressed: () => null,
                      icon: const Icon(FontAwesomeIcons.arrowLeft),
                    ),
                    const SizedBox(width: 10),
                    const UserPic(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Adel Shakal",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.glory(
                            fontSize: 20, color: kSecondColor),
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    color: kSecondColor,
                    onPressed: () => null,
                    icon: const Icon(FontAwesomeIcons.phone),
                  ),
                  IconButton(
                    color: kSecondColor,
                    onPressed: () => null,
                    icon: const Icon(FontAwesomeIcons.video),
                  ),
                  IconButton(
                    color: kSecondColor,
                    onPressed: () => null,
                    icon: const Icon(FontAwesomeIcons.ellipsisV),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        reverse: true,
                        controller: _controller,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          if (messageList[index].id == email) {
                            return MessageWidget(message: messageList[index]);
                          } else {
                            return MessageFriendsWidgetWidget(
                              message: messageList[index],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {},
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: kFourthColor,
                          child: filledSelected
                              ? const Icon(
                                  FontAwesomeIcons.microphone,
                                  color: kSecondColor,
                                )
                              : const Icon(
                                  FontAwesomeIcons.microphone,
                                  color: kSecondColor,
                                ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                messages.add({
                                  'message': value,
                                  'date': DateTime.now(),
                                  'id': email
                                });
                                _controller.animateTo(0,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn);
                                textEditingController.clear();

                              }
                            },
                            borderCircular: 50,
                            icon: FontAwesomeIcons.faceSmileBeam,
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(FontAwesomeIcons.paperPlane),
                              color: kSecondColor,
                            ),
                            color: kSecondColor,
                            controller: textEditingController,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}