import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              appCubit.screenTitles[appCubit.bottomNavBarCurrentIndex],
            ),
          ),
          body: appCubit.screens[appCubit.bottomNavBarCurrentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.comments),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.pen),
                label: 'Write Post',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.users),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'Profile',
              ),
            ],
            currentIndex: appCubit.bottomNavBarCurrentIndex,
            onTap: (index) {
              appCubit.updateBottomNavBar(
                index: index,
                context: context,
              );
            },
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  /*Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Conditional.single(
  context: context,
  conditionBuilder: (context) =>
  FirebaseAuth.instance.currentUser == null,
  widgetBuilder: (context) => const Text(
  'Not signed in',
  ),
  fallbackBuilder: (context) => const Text(
  'Signed in',
  ),
  ),
  const SizedBox(
  height: 30.0,
  ),
  TextButton(
  onPressed: () async {
  try {
  await signOut();
  // Navigate to new screen and pop the previous one
  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
  builder: (context) => LoginScreen(),
  ),
  (route) => false,
  );
  } catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
  content: Text(e.toString()),
  backgroundColor: Colors.red,
  ),
  );
  }
  },
  child: const Text(
  'Google Sign Out',
  ),
  ),
  ],
  ),
  ),*/
}
