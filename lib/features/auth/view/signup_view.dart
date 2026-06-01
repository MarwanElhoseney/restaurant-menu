import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/view/login_view.dart';
import 'package:restaurant_app/features/auth/widgets/custom_btn.dart';
import 'package:restaurant_app/share/custom_snack.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:restaurant_app/share/custom_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isLoading = false;

  final AuthRepo authRepo = AuthRepo();

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = await authRepo.signup(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const LoginView()),
          );
        }
      } catch (e) {
        String errorMsg = "Error in register";

        if (e is ApiError) {
          errorMsg = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          customSnack(errorMsg),
        );
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
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
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

                        Center(
                          child: SvgPicture.asset(
                            "assets/logo/logo.svg",
                            color: AppColors.primary,
                          ),
                        ),

                        const Gap(10),

                        Center(
                          child: CustomText(
                            text: "Welcome to Our Food App",
                            color: AppColors.primary,
                          ),
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
                                  hint: "Name",
                                  isPassword: false,
                                  controller: nameController,
                                ),

                                const Gap(15),

                                CustomTextField(
                                  hint: "Email",
                                  isPassword: false,
                                  controller: emailController,
                                ),

                                const Gap(15),

                                CustomTextField(
                                  hint: "Password",
                                  isPassword: true,
                                  controller: passwordController,
                                ),

                                const Gap(20),

                                isLoading
                                    ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 16,
                                )
                                    : CustomAuthBtn(
                                  text: "Sign up",
                                  color: AppColors.primary,
                                  textColor: Colors.white,
                                  onTap: signUp,
                                ),

                                const Gap(15),

                                CustomAuthBtn(
                                  text: "Go To Login ? ",
                                  color: Colors.white,
                                  textColor: AppColors.primary,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => const LoginView(),
                                      ),
                                    );
                                  },
                                ),

                                const Spacer(),
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
      ),
    );
  }
}