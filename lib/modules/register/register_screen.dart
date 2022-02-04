import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (BuildContext context) => RegisterCubit(),
      child: Scaffold(
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterErrorState) {
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
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name cannot be empty';
                            }
                          },
                          prefixIcon: Icons.person_outline,
                          label: 'Name',
                          keyboardType: TextInputType.text,
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
                        BlocBuilder<RegisterCubit, RegisterState>(
                          buildWhen: (previousState, currentState) =>
                              currentState
                                  is RegisterChangePasswordVisibilityState,
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
                                RegisterCubit.get(context).isPasswordObscured,
                            suffixButtonIcon: RegisterCubit.get(context)
                                .passwordVisibilityIcon,
                            onSuffixIconButtonPressed: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // TODO should be removed
                        /*defaultTextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone cannot be empty';
                            }
                          },
                          prefixIcon: Icons.phone_outlined,
                          label: 'Phone',
                          keyboardType: TextInputType.phone,
                        ),*/
                        const SizedBox(
                          height: 15.0,
                        ),
                        BlocConsumer<RegisterCubit, RegisterState>(
                          listenWhen: (previousState, currentState) =>
                              currentState is RegisterSuccessState,
                          buildWhen: (previousState, currentState) =>
                              currentState is RegisterLoadingState ||
                              currentState is RegisterErrorState,
                          listener: (context, state) async {
                            await CacheHelper.saveValue(
                              key: sharedPrefUIDKey,
                              value: (state as RegisterSuccessState).uid,
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
                          builder: (context, state) => Conditional.single(
                            context: context,
                            conditionBuilder: (context) =>
                                state is! RegisterLoadingState,
                            widgetBuilder: (context) =>
                                defaultFormSubmissionButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await RegisterCubit.get(context)
                                      .registerUserWithEmailAndPassword(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'REGISTER',
                            ),
                            fallbackBuilder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login now.',
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
                                await RegisterCubit.get(context)
                                    .registerUserWithGoogle();
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
