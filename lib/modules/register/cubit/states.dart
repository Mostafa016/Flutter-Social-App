abstract class RegisterState {}

class RegisterInitState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final String uid;

  RegisterSuccessState(this.uid);
}

class RegisterErrorState extends RegisterState {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterStoreUserDataSuccessState extends RegisterState {}

class RegisterStoreUserDataErrorState extends RegisterState {
  final String error;

  RegisterStoreUserDataErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterState {}
