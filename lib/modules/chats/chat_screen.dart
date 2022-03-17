import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatScreen extends StatelessWidget {
  final int chatRoomIndex;
  final String receiverUID;
  final String receiverName;
  final String receiverProfilePicURL;

  const ChatScreen({
    Key? key,
    required this.chatRoomIndex,
    required this.receiverUID,
    required this.receiverName,
    required this.receiverProfilePicURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      print('Chat screen :)');
      AppCubit.get(context).getChatMessages(
        chatRoomIndex: chatRoomIndex,
      );
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) => Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              AppCubit.get(context).chatMessages.isNotEmpty,
          widgetBuilder: (context) => Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        receiverProfilePicURL,
                      ),
                      radius: 25.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    receiverName,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.ellipsisV,
                    size: 16.0,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10.0,
                      ),
                      itemCount: AppCubit.get(context)
                          .chatRooms[chatRoomIndex]
                          .numOfMessages,
                      itemBuilder: (BuildContext context, int index) {
                        var appCubit = AppCubit.get(context);
                        return MessageItem(
                          isSent: appCubit.chatMessages[index].senderID ==
                              appCubit.userModel.uid,
                          message: appCubit.chatMessages[index].text,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SendMessageTextBox(chatRoomIndex: chatRoomIndex),
                ],
              ),
            ),
          ),
          fallbackBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }
}

class MessageItem extends StatelessWidget {
  final bool isSent;
  final String message;
  const MessageItem({Key? key, required this.isSent, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          child: Text(message),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSent
                ? Colors.blue.withOpacity(0.75)
                : Colors.grey.withOpacity(0.75),
            borderRadius: isSent
                ? const BorderRadius.only(
                    topLeft: Radius.circular(
                      15.0,
                    ),
                    bottomRight: Radius.circular(
                      15.0,
                    ),
                    bottomLeft: Radius.circular(
                      15.0,
                    ),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(
                      15.0,
                    ),
                    bottomRight: Radius.circular(
                      15.0,
                    ),
                    bottomLeft: Radius.circular(
                      15.0,
                    ),
                  ),
          ),
        ),
      );
}

class SendMessageTextBox extends StatefulWidget {
  final int chatRoomIndex;
  const SendMessageTextBox({Key? key, required this.chatRoomIndex})
      : super(key: key);

  @override
  State<SendMessageTextBox> createState() => _SendMessageTextBoxState();
}

class _SendMessageTextBoxState extends State<SendMessageTextBox> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageTextFieldController =
      TextEditingController();
  int _textFieldMaxLines = 1;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  void _onFocusChange() {
    _focusNode.hasFocus ? _textFieldMaxLines = 3 : _textFieldMaxLines = 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageTextFieldController,
            minLines: 1,
            maxLines: _textFieldMaxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              fillColor: Colors.black.withOpacity(0.05),
              filled: true,
            ),
            focusNode: _focusNode,
          ),
          flex: 12,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: IconButton(
            onPressed: () async {
              AudioCache player = AudioCache(prefix: 'assets/audio/');
              AppCubit.get(context).sendChatMessage(
                chatRoomIndex: widget.chatRoomIndex,
                text: _messageTextFieldController.text,
              );
              _messageTextFieldController.text = '';
              await player.play(
                'message_sound.mp3',
              );
            },
            icon: const FaIcon(FontAwesomeIcons.solidPaperPlane),
          ),
        ),
      ],
    );
  }
}
