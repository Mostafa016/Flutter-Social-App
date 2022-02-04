import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/modules/profile_edit/profile_edit_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Cover photo
              SizedBox(
                height: 200.0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              AppCubit.get(context).userModel.coverImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 54.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          AppCubit.get(context).userModel.image,
                        ),
                        radius: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                AppCubit.get(context).userModel.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 5.0,
              ),
              if (AppCubit.get(context).userModel.bio != null)
                Text(
                  AppCubit.get(context).userModel.bio!,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              if (AppCubit.get(context).userModel.bio != null)
                const SizedBox(
                  height: 10.0,
                ),
              // Categories
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            'Posts',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            '500',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            'Photos',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            '70',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            'Followers',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            '30K',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            'Following',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            '600',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Settings',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Add Photos',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(),
                        ),
                      );
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.userEdit,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
