import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/features/auth/view/login_view.dart';
import 'package:restaurant_app/features/auth/widgets/custom_btn.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:restaurant_app/share/custom_text_field.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(200),
              SvgPicture.asset(
                "assets/logo/logo.svg",
                color: AppColors.primary,
              ),
              CustomText(
                text: "Welcome to Our Food App",
                color: AppColors.primary,
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
                        CustomAuthBtn(
                          text: "Sign up",
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onTap: () {
                            if (formKey.currentState!.validate()) {}
                          },
                        ),
                        Gap(15),
                        CustomAuthBtn(
                          text: "Go To Login ? ",
                          color: Colors.white,
                          textColor: AppColors.primary,
                          onTap: () {
                            Navigator.push(
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
    );
  }
}
