import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterState> {
  bool _isPasswordObscured = true;

  bool get isPasswordObscured => _isPasswordObscured;

  IconData _passwordVisibilityIcon = Icons.visibility_outlined;

  IconData get passwordVisibilityIcon => _passwordVisibilityIcon;

  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void changePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    _passwordVisibilityIcon = _isPasswordObscured
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  Future<void> _storeUserData({
    required String uid,
    required String name,
    required String email,
    String? photoURL,
    String? coverImage,
    String? bio,
  }) async {
    UserModel userModel = UserModel(
      uid: uid,
      name: name,
      email: email,
      image: photoURL ??
          'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
      coverImage: coverImage ??
          'https://images.pexels.com/photos/2836945/pexels-photo-2836945.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      bio: bio,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toMap());
    emit(RegisterStoreUserDataSuccessState());
  }

  Future<void> registerUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        throw 'Could not register user.';
      }
      await _storeUserData(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );
      uid = userCredential.user!.uid;
      emit(RegisterSuccessState(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(e.code));
    } on String catch (e) {
      emit(RegisterErrorState(e));
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

  Future<void> registerUserWithGoogle() async {
    try {
      UserCredential? userCredential = await _signInWithGoogle();
      if (userCredential == null) {
        return;
      }
      await _storeUserData(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName!,
        email: userCredential.user!.email!,
        photoURL: userCredential.user!.photoURL,
      );
      uid = userCredential.user!.uid;
      emit(RegisterSuccessState(userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(e.code));
    } on String catch (e) {
      emit(RegisterStoreUserDataErrorState(e));
    }
  }
}
