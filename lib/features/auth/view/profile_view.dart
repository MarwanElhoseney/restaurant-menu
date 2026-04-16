import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/features/auth/widgets/custom_user_text_field.dart';
import 'package:restaurant_app/share/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();

  @override
  void initState() {
    _name.text = "marwan";
    _email.text = "marwan@gmail.com";
    _address.text = "fayoum";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            child: SvgPicture.asset("assets/test/settings.svg", width: 20),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTj9uaOHSUP94_FgVeF4BtFT6hETgBW_a8xXw&s",
                      ),
                    ),
                    border: Border.all(width: 5, color: Colors.white),
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Gap(30),
              CustomUserTextField(controller: _name, label: "Name"),
              Gap(25),
              CustomUserTextField(controller: _email, label: "Email"),
              Gap(25),

              CustomUserTextField(controller: _address, label: "Address"),
              Gap(20),
              Divider(),
              Gap(10),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 16,
                ),
                tileColor: Color(0xffF3F4F6),
                leading: Image.asset("assets/test/image 13.png", width: 50),

                title: CustomText(text: "Debit Card", color: Colors.black),
                subtitle: CustomText(
                  text: "**** ***** 2342",
                  color: Colors.black,
                ),
                trailing: CustomText(text: "Default", color: Colors.black),
              ),
              Gap(400),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade800, blurRadius: 20)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomText(text: "Edit Profile", color: Colors.white),
                    Gap(5),
                    Icon(CupertinoIcons.pencil, color: Colors.white),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomText(text: "Logout", color: AppColors.primary),
                    Gap(5),
                    Icon(Icons.logout, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
