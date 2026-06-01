import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/view/signup_view.dart';
import 'package:restaurant_app/features/auth/widgets/custom_btn.dart';
import 'package:restaurant_app/root.dart';
import 'package:restaurant_app/share/custom_snack.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:restaurant_app/share/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final AuthRepo authRepo = AuthRepo();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = await authRepo.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const Root()),
          );
        }
      } catch (e) {
        String errorMsg = "Unhandled error in login";

        if (e is ApiError) {
          errorMsg = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery
                    .of(context)
                    .size
                    .height,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Gap(100),

                      SvgPicture.asset(
                        "assets/logo/logo.svg",
                        color: AppColors.primary,
                      ),

                      const Gap(10),

                      CustomText(
                        text: "Welcome Back , Discover The Fast",
                        size: 13,
                        color: AppColors.primary,
                        weight: FontWeight.w500,
                      ),

                      const Gap(50),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Gap(30),

                              CustomTextField(
                                controller: emailController,
                                hint: "Email",
                                isPassword: false,
                              ),

                              const Gap(15),

                              CustomTextField(
                                controller: passwordController,
                                hint: "Password",
                                isPassword: true,
                              ),

                              const Gap(20),

                              isLoading
                                  ? const CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 16,
                              )
                                  : CustomAuthBtn(
                                text: "Log in",
                                color: AppColors.primary,
                                textColor: Colors.white,
                                onTap: login,
                              ),

                              const Gap(15),

                              CustomAuthBtn(
                                text: "Create Account ? ",
                                color: Colors.white,
                                textColor: AppColors.primary,
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => const SignupView(),
                                    ),
                                  );
                                },
                              ),

                              const Gap(20),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => const Root(),
                                    ),
                                  );
                                },
                                child: CustomText(
                                  text: "Go as a guest?",
                                  color: Colors.blue,
                                  weight: FontWeight.bold,
                                  size: 13,
                                ),
                              ),

                              const Spacer()
                            ],
                          ),
                        ),
                      ),
                    ],
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