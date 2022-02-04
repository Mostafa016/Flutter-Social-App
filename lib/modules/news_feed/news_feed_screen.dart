import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppGetNewsFeedPostsErrorState &&
            state.error == "Bad state: No element") {
          //TODO: Extract this to its own function or widget
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No new posts found."),
            ),
          );
        }
      },
      builder: (context, state) => Conditional.single(
        context: context,
        conditionBuilder: (context) => AppCubit.get(context).posts.isNotEmpty,
        widgetBuilder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () => AppCubit.get(context).refreshPosts(),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) => buildPost(
                context: context,
                index: index,
                post: AppCubit.get(context).posts[index],
              ),
              itemCount: AppCubit.get(context).posts.length,
            ),
          ),
        ),
        fallbackBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
