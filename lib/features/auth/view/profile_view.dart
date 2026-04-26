import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/data/user_model.dart';
import 'package:restaurant_app/features/auth/view/login_view.dart';
import 'package:restaurant_app/features/auth/widgets/custom_user_text_field.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_snack.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();
  UserModel? userModel;
  bool isLoading = false;

  AuthRepo authRepo = AuthRepo();
  String? selectedImage;

  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = "Error in profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(CustomSnack(errorMsg));
    }
  }

  Future<void> updateProfileData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final user = await authRepo.updateProfileData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        address: _address.text.trim(),
        visa: _visa.text.trim(),
        imagePath: selectedImage,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnack("profile updated successfully"));

      setState(() {
        isLoading = false;
      });

      setState(() {
        userModel = user;
      });
      await getProfileData();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMsg = "Error in profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(CustomSnack(errorMsg));
    }
  }

  Future<void> pickImage() async {
    final pickedimage = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        selectedImage = pickedimage.path;
      });
    }
  }


  @override
  void initState() {
    getProfileData().then((v) {
      _name.text = userModel?.name.toString() ?? "";
      _email.text = userModel?.email.toString() ?? "";
      _address.text = userModel?.address.toString() ?? "";
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.primary,
      color: Colors.white,
      displacement: 60,
      onRefresh: () async {
        await getProfileData();
      },
      child: Scaffold(
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


            child: Skeletonizer(
              enabled: userModel == null || userModel?.image?.isEmpty == true,
              child: Column(
                children: [
                  Center(

                    child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(
                                File(selectedImage ?? ""),
                              ),
                              fit: BoxFit.cover
                          ),
                          border: Border.all(width: 3, color: AppColors
                              .primary),
                          color: Colors.grey.shade300,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: selectedImage != null
                            ? Image.file(
                          File(selectedImage!), fit: BoxFit.cover,)
                            : (userModel?.image != null &&
                            userModel!.image!.isNotEmpty)
                            ? Image.network(
                          userModel!.image!, fit: BoxFit.cover,
                          errorBuilder: (context, err, builder) =>
                              Icon(Icons.person),)
                            : Icon(Icons.person)
                    ),
                  ),
                  Gap(10),

                  CustomButton(
                      onTap: pickImage,
                      radius: 50,
                      width: 138,
                      height: 40,
                      text: "upload image"),
                  Gap(30),
                  CustomUserTextField(controller: _name, label: "Name"),
                  Gap(25),
                  CustomUserTextField(controller: _email, label: "Email"),
                  Gap(25),

                  CustomUserTextField(controller: _address, label: "Address"),
                  Gap(20),
                  Divider(),
                  Gap(10),


                  userModel?.visa == null ?
                  CustomUserTextField(controller: _visa, label: "ADD VISA CARD"
                    , textInputType: TextInputType.number,
                  )
                      : ListTile(
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
                      text: userModel?.visa ?? "".toString() ?? "",
                      color: Colors.black,
                    ),
                    trailing: CustomText(text: "Default", color: Colors.black),
                  ),


                  Gap(400),
                ],
              ),
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

                GestureDetector(
                  onTap: updateProfileData,

                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : Container(

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
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => LoginView()));
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
