import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/news_feed/news_feed_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/modules/write_post/write_post_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:social_app/shared/network/local/cache_helper.dart';

enum ImageType {
  profile,
  cover,
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitState());
  int _bottomNavBarCurrentIndex = 0;
  int get bottomNavBarCurrentIndex => _bottomNavBarCurrentIndex;
  final List<String> screenTitles = List.unmodifiable([
    'Home',
    'Chats',
    'Write Post',
    'Users',
    'Profile',
  ]);
  final List<Widget> screens = List.unmodifiable([
    const NewsFeedScreen(),
    const ChatsScreen(),
    WritePostScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ]);
  late UserModel userModel;
  List<PostModel> posts = [];
  List<String> postIDs = [];
  List<bool> postLikedByUser = [];
  File? pickedProfileImage;
  File? pickedCoverImage;
  File? pickedPostImage;
  var usernameController = TextEditingController();
  var bioController = TextEditingController();
  bool hasUserLoggedOut = false;
  var lastLoadedPostDoc;
  bool isPostEmpty = true;

  Future<void> _getUserData() async {
    emit(AppGetUserDataLoadingState());
    var document =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (document.data() == null) {
      throw 'Could not get user data.';
    }
    userModel = UserModel.fromJson(document.data()!);
    emit(AppGetUserDataSuccessState());
  }

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  void updateBottomNavBar({
    required int index,
    required BuildContext context,
  }) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WritePostScreen(),
        ),
      );
    } else {
      _bottomNavBarCurrentIndex = index;
      emit(AppChangeBottomNavBarIndexState());
    }
  }

  Future<File?> pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      emit(AppPickImageSuccessState());
      return pickedImage == null ? null : File(pickedImage.path);
    } catch (e) {
      emit(AppPickImageErrorState(e.toString()));
    }
  }

  Future<void> _updateImageInFirestore({
    required String uid,
    required String imageURL,
    required ImageType imageType,
  }) async {
    String key;
    if (imageType == ImageType.profile) {
      key = 'image';
    } else {
      key = 'coverImage';
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({key: imageURL});
      await _getUserData();
    } catch (e) {
      emit(AppUserUpdateCoverImageErrorState());
    }
  }

  Future<void> updateUsernameInFirestore({
    required String uid,
    required String username,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': username});
      await _getUserData();
    } catch (e) {
      emit(AppUserUpdateCoverImageErrorState());
    }
  }

  Future<void> updateBioInFirestore({
    required String uid,
    required String bio,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'bio': bio});
      await _getUserData();
    } catch (e) {
      emit(AppUserUpdateCoverImageErrorState());
    }
  }

  Future<void> uploadImageToFirebaseStorage({
    required String uid,
    required File imageFile,
    required ImageType imageType,
  }) async {
    emit(AppUploadImageLoadingState());
    try {
      firebase_storage.TaskSnapshot taskSnapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(imageFile.path).pathSegments.last}')
          .putFile(imageFile);
      String imageURL = await taskSnapshot.ref.getDownloadURL();
      await _updateImageInFirestore(
        uid: uid,
        imageURL: imageURL,
        imageType: imageType,
      );
      emit(AppUploadImageSuccessState());
    } catch (e) {
      emit(AppUploadImageErrorState(e.toString()));
    }
  }

  void resetProfileChanges() {
    pickedProfileImage = null;
    pickedCoverImage = null;
    usernameController.text = userModel.name;
    bioController.text = userModel.bio ?? '';
    emit(AppResetProfileChangesState());
  }

  void refresh() {
    emit(AppFieldSubmittedState());
  }

  void removePostImage() {
    pickedPostImage = null;
    emit(AppRemovePostImageState());
  }

  Future<void> _addPostToFirestore({
    required String textContent,
    String? postImageURL,
  }) async {
    emit(AppAddPostToFirestoreLoadingState());
    PostModel postModel = PostModel(
      uid: userModel.uid,
      name: userModel.name,
      userImage: userModel.image,
      dateTime: DateTime.now().toString(),
      textContent: textContent,
      numOfLikes: 0,
      postImage: postImageURL,
    );
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .add(postModel.toMap());
      emit(AppAddPostToFirestoreSuccessState());
    } catch (e) {
      emit(AppAddPostToFirestoreErrorState(e.toString()));
    }
  }

  Future<void> _uploadPostImageToFirebaseStorage({
    required String textContent,
  }) async {
    emit(AppUploadImageLoadingState());
    try {
      firebase_storage.TaskSnapshot taskSnapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(pickedPostImage!.path).pathSegments.last}')
          .putFile(pickedPostImage!);
      String postImageURL = await taskSnapshot.ref.getDownloadURL();
      await _addPostToFirestore(
          textContent: textContent, postImageURL: postImageURL);
      emit(AppUploadImageSuccessState());
    } catch (e) {
      emit(AppUploadImageErrorState(e.toString()));
    }
  }

  Future<void> createPost({
    required TextEditingController textContentController,
  }) async {
    print('in createPost');
    //Allow posts that have text only or an image only or both (simplified condition using boolean algebra)
    if (!(textContentController.text.isNotEmpty ||
        (textContentController.text.isEmpty && pickedPostImage != null))) {
      emit(AppCreateEmptyPostState());
      isPostEmpty = true;
      return;
    }
    isPostEmpty = false;
    pickedPostImage == null
        ? await _addPostToFirestore(textContent: textContentController.text)
        : await _uploadPostImageToFirebaseStorage(
            textContent: textContentController.text);
    textContentController.clear();
    pickedPostImage = null;
  }

  Future<void> _getNewsFeedPosts({bool isRefresh = false}) async {
    //TODO: Find a cleaner way to handle loading posts after refreshing
    if (!isRefresh) {
      posts = [];
      postIDs = [];
      postLikedByUser = [];
    }
    if (isRefresh) {
      //print("Here");
      FirebaseFirestore.instance
          .collection('posts')
          .orderBy('dateTime', descending: true)
          .endBeforeDocument(lastLoadedPostDoc)
          .get()
          .then((postsCollection) async {
        for (var document in postsCollection.docs.reversed) {
          bool doesUserLikeDocExist = (await document.reference
                  .collection('likes')
                  .doc(userModel.uid)
                  .get())
              .exists;
          postIDs.insert(0, document.id);
          posts.insert(0, PostModel.fromJson(document.data()));
          //print('$doesUserLikeDocExist');
          postLikedByUser.add(doesUserLikeDocExist);
        }
        lastLoadedPostDoc = postsCollection.docs.first;
        emit(AppGetNewsFeedPostsSuccessState());
        //print('Exit :)');
      }).catchError((error) {
        print(error.toString());
        emit(AppGetNewsFeedPostsErrorState(error.toString()));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .orderBy('dateTime', descending: true)
          .get()
          .then((postsCollection) async {
        for (var document in postsCollection.docs) {
          bool doesUserLikeDocExist = (await document.reference
                  .collection('likes')
                  .doc(userModel.uid)
                  .get())
              .exists;
          postIDs.add(document.id);
          posts.add(PostModel.fromJson(document.data()));
          //print('$doesUserLikeDocExist');
          postLikedByUser.add(doesUserLikeDocExist);
        }
        lastLoadedPostDoc = postsCollection.docs.first;
        emit(AppGetNewsFeedPostsSuccessState());
        //print('Exit :)');
      }).catchError((error) {
        print(error.toString());
        emit(AppGetNewsFeedPostsErrorState(error.toString()));
      });
    }
  }

/*
  void getNewsFeedPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var document in value.docs) {
        document.reference
            .collection('likes')
            .doc(userModel.uid)
            .get()
            .then((value) {
          postIDs.add(document.id);
          posts.add(PostModel.fromJson(document.data()));
          print('${value.data()!['isLiked']}');
          postLikedByUser.add(value.data()!['isLiked']);
        }).catchError((error) {
          print(error.toString());
          emit(AppGetNewsFeedPostsErrorState(error.toString()));
        });
      }
      emit(AppGetNewsFeedPostsSuccessState());
      print('Exit :)');
    }).catchError((error) {
      print(error.toString());
      emit(AppGetNewsFeedPostsErrorState(error.toString()));
    });
  }
*/

  Future<void> changeReactionOnPost({
    required int postIndex,
  }) async {
    bool wasLiked = postLikedByUser[postIndex];
    postLikedByUser[postIndex] = !wasLiked;
    wasLiked ? posts[postIndex].numOfLikes-- : posts[postIndex].numOfLikes++;
    emit(AppChangeReactionOnPostLoadingState());
    try {
      var postDocReference = FirebaseFirestore.instance
          .collection('posts')
          .doc(postIDs[postIndex]);
      /*await postDocReference
          .collection('likes')
          .doc(userModel.uid)
          .set({'isLiked': !wasLiked});*/
      var userLikeDoc = postDocReference.collection('likes').doc(userModel.uid);
      wasLiked
          ? await userLikeDoc.delete()
          : await userLikeDoc.set(<String, dynamic>{});
      /* await postDocReference.update({
        'numOfLikes': posts[postIndex].numOfLikes,
      });*/
      // Atomically change the value
      await postDocReference.update({
        'numOfLikes': FieldValue.increment(wasLiked ? -1 : 1),
      });
      emit(AppChangeReactionOnPostSuccessState());
    } catch (e) {
      bool wasLiked = postLikedByUser[postIndex];
      postLikedByUser[postIndex] = !wasLiked;
      if (wasLiked) {
        posts[postIndex].numOfLikes--;
      } else {
        posts[postIndex].numOfLikes++;
      }
      print(e.toString());
      emit(AppChangeReactionOnPostErrorState(e.toString()));
    }
  }

  Future<void> refreshPosts() async {
    emit(AppRefreshLoadingState());
    await _getNewsFeedPosts(isRefresh: true);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    while (!await CacheHelper.removeValue(sharedPrefUIDKey)) {}
    uid = null;
  }

  void getHomeLayoutData() async {
    await _getUserData();
    await _getNewsFeedPosts();
  }
}
