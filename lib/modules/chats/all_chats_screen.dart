import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) => Conditional.single(
        context: context,
        conditionBuilder: (context) =>
            AppCubit.get(context).chatRooms.isNotEmpty,
        widgetBuilder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: AppCubit.get(context).chatRooms.length,
            itemBuilder: (context, index) => ChatRoomSummaryTile(index: index),
          ),
        ),
        fallbackBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ChatRoomSummaryTile extends StatelessWidget {
  final int index;
  const ChatRoomSummaryTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          AppCubit.get(context).chatRoomImages[index],
        ),
        radius: 30.0,
      ),
      title: Text(
        AppCubit.get(context).receiverName[index],
      ),
      subtitle: Text(
        AppCubit.get(context).lastMessageSendersUID[index] ==
                AppCubit.get(context).userModel.uid
            ? 'You: ' + AppCubit.get(context).lastMessageTexts[index]
            : AppCubit.get(context).lastMessageTexts[index],
      ),
      onTap: () {
        //TODO: navigate to specific chatroom and load messages bla bla
        /* AppCubit.get(context).getChatMessages(
          chatRoomIndex: index,
        );*/
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomIndex: index,
              receiverUID: AppCubit.get(context).lastMessageSendersUID[index],
              receiverName: AppCubit.get(context).receiverName[index],
              receiverProfilePicURL:
                  AppCubit.get(context).chatRoomImages[index],
            ),
          ),
        );
      },
    );
  }
}
