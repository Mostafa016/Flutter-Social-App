import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';

class LoginCubit extends Cubit<LoginState> {
  bool _isPasswordObscured = true;

  bool get isPasswordObscured => _isPasswordObscured;

  IconData _passwordVisibilityIcon = Icons.visibility_outlined;

  IconData get passwordVisibilityIcon => _passwordVisibilityIcon;

  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void changePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    _passwordVisibilityIcon = _isPasswordObscured
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(LoginChangePasswordVisibilityState());
  }

  Future<void> loginUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        throw 'Could not register user.';
      }
      uid = userCredential.user!.uid;
      emit(LoginSuccessState(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(e.code));
    } on String catch (e) {
      emit(LoginErrorState(e));
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> loginUserWithGoogle() async {
    emit(LoginLoadingState());
    try {
      UserCredential? userCredential = await _signInWithGoogle();
      if (userCredential == null) {
        return;
      }
      uid = userCredential.user!.uid;
      emit(LoginSuccessState(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(e.code));
    } on String catch (e) {
      emit(LoginStoreUserDataErrorState(e));
    }
  }
}
