abstract class AppState {}

class AppInitState extends AppState {}

class AppChangeBottomNavBarIndexState extends AppState {}

class AppGetUserDataLoadingState extends AppState {}

class AppGetUserDataSuccessState extends AppState {}

class AppGetUserDataErrorState extends AppState {
  final String error;

  AppGetUserDataErrorState(this.error);
}

class AppPickImageSuccessState extends AppState {}

class AppPickImageErrorState extends AppState {
  final String error;

  AppPickImageErrorState(this.error);
}

class AppUserUpdateCoverImageErrorState extends AppState {}

class AppUserUpdateProfileImageErrorState extends AppState {}

class AppUploadImageLoadingState extends AppState {}

class AppUploadImageSuccessState extends AppState {}

class AppUploadImageErrorState extends AppState {
  final String error;

  AppUploadImageErrorState(this.error);
}

class AppResetProfileChangesState extends AppState {}

class AppFieldSubmittedState extends AppState {}

class AppAddPostToFirestoreLoadingState extends AppState {}

class AppAddPostToFirestoreSuccessState extends AppState {}

class AppAddPostToFirestoreErrorState extends AppState {
  final String error;

  AppAddPostToFirestoreErrorState(this.error);
}

class AppRemovePostImageState extends AppState {}

class AppCreateEmptyPostState extends AppState {}

class AppGetNewsFeedPostsSuccessState extends AppState {}

class AppGetNewsFeedPostsErrorState extends AppState {
  final String error;

  AppGetNewsFeedPostsErrorState(this.error);
}

class AppChangeReactionOnPostLoadingState extends AppState {}

class AppChangeReactionOnPostSuccessState extends AppState {}

class AppChangeReactionOnPostErrorState extends AppState {
  final String error;

  AppChangeReactionOnPostErrorState(this.error);
}

class AppRefreshLoadingState extends AppState {}
