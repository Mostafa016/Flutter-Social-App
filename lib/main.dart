import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('onBackgroundMessage');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print(await messaging.getToken());
  FirebaseMessaging.onMessage.listen((event) {
    print('onMessage');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('onMessageOpenedApp');
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  uid = CacheHelper.getValue('uid');
  runApp(MyApp(
    startingScreen: uid == null ? LoginScreen() : const HomeLayout(),
    isUIDInSharedPref: uid != null,
  ));
}

class MyApp extends StatelessWidget {
  final bool isUIDInSharedPref;
  final Widget startingScreen;

  const MyApp({
    Key? key,
    required this.startingScreen,
    required this.isUIDInSharedPref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) =>
          isUIDInSharedPref ? (AppCubit()..getHomeLayoutData()) : AppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: startingScreen,
      ),
    );
  }
}
