import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/details/details_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import 'constants.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String?)? validator,
  required IconData prefixIcon,
  required String label,
  required TextInputType keyboardType,
  IconData? suffixButtonIcon,
  void Function()? onSuffixIconButtonPressed,
  bool obscureText = false,
  void Function(String)? onFieldSubmitted,
}) =>
    TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
        ),
        labelText: label,
        suffixIcon: suffixButtonIcon == null
            ? null
            : IconButton(
                onPressed: onSuffixIconButtonPressed,
                icon: Icon(
                  suffixButtonIcon,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
    );

Widget defaultFormSubmissionButton({
  required void Function() onPressed,
  required String text,
}) =>
    MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
      color: Colors.blue,
      minWidth: double.infinity,
      padding: const EdgeInsets.all(10.0),
      textColor: Colors.white,
    );

Widget defaultContinueWithButton({
  required void Function() onPressed,
  required String pathToImage,
  required String text,
}) =>
    Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image(
                image: AssetImage(pathToImage),
                height: 30.0,
                width: 30.0,
              ),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );

class DefaultContinueWithButton extends StatelessWidget {
  final void Function() _onPressed;
  final String _pathToImage;
  final String _text;

  const DefaultContinueWithButton(
      {required void Function() onPressed,
      required String pathToImage,
      required String text,
      Key? key})
      : _onPressed = onPressed,
        _pathToImage = pathToImage,
        _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image(
                image: AssetImage(_pathToImage),
                height: 30.0,
                width: 30.0,
              ),
              Expanded(
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget hashtagTextButton({
  required String text,
  void Function()? onPressed,
}) =>
    Padding(
      padding: const EdgeInsetsDirectional.only(
        end: 8.0,
      ),
      child: SizedBox(
        height: 25.0,
        child: MaterialButton(
          padding: EdgeInsets.zero,
          minWidth: 1.0,
          onPressed: () {},
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );

Widget buildPost({
  required BuildContext context,
  required int index,
  required PostModel post,
}) =>
    Card(
      color: Colors.white,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    post.userImage,
                  ),
                  radius: 30.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.solidCheckCircle,
                          color: Colors.blue,
                          size: 15.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      post.dateTime,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.ellipsisH,
                    size: 14.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            ReadMoreText(
              post.textContent,
              style: const TextStyle(
                color: Colors.black,
              ),
              moreStyle: const TextStyle(
                color: Colors.blue,
              ),
              lessStyle: const TextStyle(
                color: Colors.blue,
              ),
              delimiter: ' ',
            ),
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                children: [
                  hashtagTextButton(
                    text: '#blessed',
                  ),
                  hashtagTextButton(
                    text: '#live_love_laugh',
                  ),
                  hashtagTextButton(
                    text: '#stop_the_count',
                  ),
                  hashtagTextButton(
                    text: '#china_virus_is_fake',
                  ),
                ],
              ),
            ),
            Conditional.single(
              context: context,
              conditionBuilder: (context) => post.postImage != null,
              widgetBuilder: (context) => Column(
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetailsScreen(
                            imageURL: post.postImage!,
                          ),
                        ),
                        /*MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            imageURL: post.postImage!,
                            heroTag: postImageHeroTag + index.toString(),
                          ),
                        ),*/
                      );
                    },
                    child: Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            post.postImage!,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
              fallbackBuilder: (context) => const SizedBox.shrink(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        FaIcon(
                          AppCubit.get(context).postLikedByUser[index]
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${post.numOfLikes}',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1.0,
                  color: Colors.grey,
                  height: 22.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.commentDots,
                          color: Colors.amber,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '57',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    post.userImage,
                  ),
                  radius: 24.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await AppCubit.get(context).changeReactionOnPost(
                            postIndex: index,
                          );
                        },
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.red,
                              size: 20.0,
                            ),
                            Text(
                              'Like',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 14.0,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.grey,
                        height: 48.0,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.shareSquare,
                              color: Colors.green,
                              size: 18.0,
                            ),
                            Text(
                              'Share',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontSize: 14.0,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

