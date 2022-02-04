import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (BuildContext context) => LoginCubit(),
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.error,
                ),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            }
                          },
                          prefixIcon: Icons.email_outlined,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        BlocBuilder<LoginCubit, LoginState>(
                          buildWhen: (previousState, currentState) =>
                              currentState
                                  is LoginChangePasswordVisibilityState,
                          builder: (context, state) => defaultTextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              }
                            },
                            prefixIcon: Icons.password_outlined,
                            label: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:
                                LoginCubit.get(context).isPasswordObscured,
                            suffixButtonIcon:
                                LoginCubit.get(context).passwordVisibilityIcon,
                            onSuffixIconButtonPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        BlocConsumer<LoginCubit, LoginState>(
                          listenWhen: (previousState, currentState) =>
                              currentState is LoginSuccessState,
                          buildWhen: (previousState, currentState) =>
                              currentState is LoginLoadingState,
                          listener: (context, state) async {
                            await CacheHelper.saveValue(
                              key: sharedPrefUIDKey,
                              value: (state as LoginSuccessState).uid,
                            );
                            AppCubit.get(context).getHomeLayoutData();
                            // Navigate to new screen and pop the previous one
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeLayout(),
                              ),
                              (route) => false,
                            );
                          },
                          builder: (context, state) =>
                              defaultFormSubmissionButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await LoginCubit.get(context)
                                    .loginUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                );
                              }
                            },
                            text: 'LOGIN',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Register now.',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Builder(
                          builder: (context) {
                            return DefaultContinueWithButton(
                              onPressed: () async {
                                await LoginCubit.get(context)
                                    .loginUserWithGoogle();
                              },
                              pathToImage: 'assets/images/google-logo.png',
                              text: 'Continue with Google',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
