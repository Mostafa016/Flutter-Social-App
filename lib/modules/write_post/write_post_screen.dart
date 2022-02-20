import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class WritePostScreen extends StatelessWidget {
  final textContentController = TextEditingController();

  WritePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(listener: (context, state) {
      if (state is AppCreateEmptyPostState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("A post must at least contain some text or an image."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Write post',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await AppCubit.get(context)
                    .createPost(textContentController: textContentController);
                if (!AppCubit.get(context).isPostEmpty) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Post',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      AppCubit.get(context).userModel.image,
                    ),
                    radius: 30.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    AppCubit.get(context).userModel.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What is on your mind?',
                  ),
                  controller: textContentController,
                  maxLines: null,
                  expands: true,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    AppCubit.get(context).pickedPostImage != null,
                widgetBuilder: (context) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 150.0,
                      margin: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            AppCubit.get(context).pickedPostImage!,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).removePostImage();
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.times,
                            size: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                fallbackBuilder: (context) => const SizedBox.shrink(),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        AppCubit.get(context).pickedPostImage =
                            await AppCubit.get(context).pickImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.image,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Add photo',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.hashtag,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Tags',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
