import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ProfileEditScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  ProfileEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      buildWhen: (previous, current) => current is! AppFieldSubmittedState,
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        //appCubit.usernameController.text = appCubit.userModel.name;
        //appCubit.bioController.text = appCubit.userModel.bio ?? '';
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: const Text('Edit Profile'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Cover photo and profile picture
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 150.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: appCubit.pickedCoverImage == null
                                        ? NetworkImage(
                                            appCubit.userModel.coverImage,
                                          )
                                        : FileImage(
                                            appCubit.pickedCoverImage!,
                                          ) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  child: IconButton(
                                    onPressed: () async {
                                      File? pickedImage =
                                          await appCubit.pickImage();
                                      if (pickedImage == null ||
                                          state is AppPickImageErrorState) {
                                        return;
                                      }
                                      appCubit.pickedCoverImage = pickedImage;
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.camera,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 54.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    appCubit.pickedProfileImage == null
                                        ? NetworkImage(
                                            appCubit.userModel.image,
                                          )
                                        : FileImage(
                                            appCubit.pickedProfileImage!,
                                          ) as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: IconButton(
                                  onPressed: () async {
                                    File? pickedImage =
                                        await appCubit.pickImage();
                                    if (pickedImage == null ||
                                        state is AppPickImageErrorState) {
                                      return;
                                    }
                                    appCubit.pickedProfileImage = pickedImage;
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.camera,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    appCubit.userModel.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  if (appCubit.userModel.bio != null)
                    Text(
                      appCubit.userModel.bio!,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  if (appCubit.userModel.bio != null)
                    const SizedBox(
                      height: 10.0,
                    ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        defaultTextFormField(
                          controller: appCubit.usernameController,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Username cannot be empty';
                            }
                          },
                          prefixIcon: FontAwesomeIcons.user,
                          label: 'Username',
                          keyboardType: TextInputType.name,
                          onFieldSubmitted: (value) {
                            appCubit.refresh();
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: appCubit.bioController,
                          validator: (text) {},
                          prefixIcon: FontAwesomeIcons.pen,
                          label: 'Bio',
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (value) {
                            appCubit.refresh();
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        BlocBuilder<AppCubit, AppState>(
                          buildWhen: (previous, current) =>
                              current is AppFieldSubmittedState,
                          builder: (context, state) {
                            print(appCubit.usernameController.text.trim());
                            return Conditional.single(
                              context: context,
                              conditionBuilder: (context) =>
                                  appCubit.pickedProfileImage != null ||
                                  appCubit.pickedCoverImage != null ||
                                  appCubit.usernameController.text.trim() !=
                                      appCubit.userModel.name ||
                                  appCubit.bioController.text.trim() !=
                                      appCubit.userModel.bio,
                              widgetBuilder: (context) => Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Text(
                                          'Cancel',
                                        ),
                                      ),
                                      onPressed: () {
                                        appCubit.resetProfileChanges();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: OutlinedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Text(
                                          'Save changes',
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }
                                        if (appCubit.pickedProfileImage !=
                                            null) {
                                          await appCubit
                                              .uploadImageToFirebaseStorage(
                                            uid: uid!,
                                            imageFile:
                                                appCubit.pickedProfileImage!,
                                            imageType: ImageType.profile,
                                          );
                                        }
                                        if (appCubit.pickedCoverImage != null) {
                                          await appCubit
                                              .uploadImageToFirebaseStorage(
                                            uid: uid!,
                                            imageFile:
                                                appCubit.pickedCoverImage!,
                                            imageType: ImageType.cover,
                                          );
                                        }
                                        if (appCubit.usernameController.text
                                                .trim() !=
                                            appCubit.userModel.name) {
                                          await appCubit
                                              .updateUsernameInFirestore(
                                            uid: uid!,
                                            username: appCubit
                                                .usernameController.text
                                                .trim(),
                                          );
                                        }
                                        if (appCubit.bioController.text
                                                .trim() !=
                                            appCubit.userModel.bio) {
                                          await appCubit.updateBioInFirestore(
                                            uid: uid!,
                                            bio: appCubit.bioController.text
                                                .trim(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              fallbackBuilder: (context) =>
                                  const SizedBox.shrink(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
