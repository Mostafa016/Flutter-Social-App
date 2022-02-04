import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  await AppCubit.get(context).signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Row(
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.signOutAlt,
                      size: 18.0,
                    ),
                    Expanded(
                      child: Text(
                        'Log Out',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
