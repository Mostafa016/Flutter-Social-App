abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String uid;

  LoginSuccessState(this.uid);
}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}

// TODO clean up those states or rename them
class LoginStoreUserDataSuccessState extends LoginState {}

class LoginStoreUserDataErrorState extends LoginState {
  final String error;

  LoginStoreUserDataErrorState(this.error);
}

class LoginChangePasswordVisibilityState extends LoginState {}
