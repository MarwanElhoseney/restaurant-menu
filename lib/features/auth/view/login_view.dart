import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/features/auth/view/signup_view.dart';
import 'package:restaurant_app/features/auth/widgets/custom_btn.dart';
import 'package:restaurant_app/root.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:restaurant_app/share/custom_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Gap(200),
                SvgPicture.asset(
                  "assets/logo/logo.svg",
                  color: AppColors.primary,
                ),
                Gap(10),
                CustomText(
                  text: "Welcome Back , Discover The Fast",
                  size: 13,
                  color: AppColors.primary,
                  weight: FontWeight.w500,
                ),
                Gap(60),

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
                    child: Column(
                      children: [
                        Gap(30),
                        CustomTextField(
                          controller: emailController,
                          hint: "Email",
                          isPassword: false,
                        ),
                        Gap(15),
                        CustomTextField(
                          controller: passwordController,
                          hint: "Password",
                          isPassword: true,
                        ),
                        Gap(20),
                        CustomAuthBtn(
                          text: "Log in",
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onTap: () {
                            if (formKey.currentState!.validate()) {}
                          },
                        ),
                        Gap(15),
                        CustomAuthBtn(
                          text: "Create Account ? ",

                          color: Colors.white,
                          textColor: AppColors.primary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) {
                                  return SignupView();
                                },
                              ),
                            );
                          },
                        ),

                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) {
                                  return Root();
                                },
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
                      ],
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
