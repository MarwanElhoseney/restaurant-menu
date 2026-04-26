import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/view/login_view.dart';
import 'package:restaurant_app/features/auth/widgets/custom_btn.dart';
import 'package:restaurant_app/root.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  AuthRepo authRepo = AuthRepo();

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        final user = await authRepo.signup(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => Root()));
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        String errorMsg = "Error in register";
        if (e is ApiError) {
          errorMsg = e.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(CustomSnack(errorMsg));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(200),
                Center(
                  child: SvgPicture.asset(
                    "assets/logo/logo.svg",
                    color: AppColors.primary,
                  ),
                ),
                Center(
                  child: CustomText(
                    text: "Welcome to Our Food App",
                    color: AppColors.primary,
                  ),
                ),
                Gap(100),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Gap(30),
                          CustomTextField(
                            hint: "Name",
                            isPassword: false,
                            controller: nameController,
                          ),
                          Gap(15),
                          CustomTextField(
                            hint: "Email",
                            isPassword: false,
                            controller: emailController,
                          ),
                          Gap(15),
                          CustomTextField(
                            hint: "Password",
                            isPassword: true,
                            controller: passwordController,
                          ),
                          Gap(20),
                          isLoading
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : CustomAuthBtn(
                                text: "Sign up",
                                color: AppColors.primary,
                                textColor: Colors.white,
                                onTap: signUp,
                              ),
                          Gap(15),
                          CustomAuthBtn(
                            text: "Go To Login ? ",
                            color: Colors.white,
                            textColor: AppColors.primary,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (c) {
                                    return LoginView();
                                  },
                                ),
                              );
                            },
                          ),
                          Gap(200),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
