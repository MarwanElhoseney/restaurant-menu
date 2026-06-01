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
  bool isGuest = false;
  bool isLogoutLoading = false;

  final AuthRepo authRepo = AuthRepo();
  String? selectedImage;

  Future<void> loadProfile() async {
    try {
      final user = await authRepo.autoLogin();

      if (!mounted) return;

      setState(() {
        isGuest = authRepo.isGuest;
        userModel = user;
      });

      if (user != null) {
        _name.text = user.name;
        _email.text = user.email;
        _address.text = user.address ?? "";
        _visa.text = user.visa ?? "";
      }
    } catch (e) {
      String errorMsg = "Error in profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(errorMsg),
      );
    }
  }

  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();

      if (!mounted) return;

      if (user != null) {
        setState(() {
          userModel = user;
        });

        _name.text = user.name;
        _email.text = user.email;
        _address.text = user.address ?? "";
        _visa.text = user.visa ?? "";
      }
    } catch (e) {
      String errorMsg = "Error in profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(errorMsg),
      );
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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack("Profile updated successfully"),
      );

      setState(() {
        userModel = user;
        isLoading = false;
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

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(errorMsg),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
      });
    }
  }

  Future<void> logout() async {
    setState(() {
      isLogoutLoading = true;
    });

    try {
      await authRepo.logout();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => LoginView()),
      );
    } catch (e) {
      String errorMsg = "Logout failed";
      if (e is ApiError) {
        errorMsg = e.message;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(errorMsg),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLogoutLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _address.dispose();
    _visa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return Scaffold(
        body: Center(
          child: Text("Guest Mode"),
        ),
      );
    }

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
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                "assets/test/settings.svg",
                width: 20,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Skeletonizer(
              enabled: userModel == null,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: AppColors.primary,
                        ),
                        color: Colors.grey.shade300,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: selectedImage != null
                          ? Image.file(
                        File(selectedImage!),
                        fit: BoxFit.cover,
                      )
                          : (userModel?.image != null &&
                          userModel!.image!.isNotEmpty)
                          ? Image.network(
                        userModel!.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person),
                      )
                          : const Icon(Icons.person),
                    ),
                  ),
                  const Gap(10),

                  CustomButton(
                    onTap: pickImage,
                    radius: 50,
                    width: 138,
                    height: 40,
                    text: "Upload Image",
                  ),

                  const Gap(30),

                  CustomUserTextField(
                    controller: _name,
                    label: "Name",
                  ),

                  const Gap(25),

                  CustomUserTextField(
                    controller: _email,
                    label: "Email",
                  ),

                  const Gap(25),

                  CustomUserTextField(
                    controller: _address,
                    label: "Address",
                  ),

                  const Gap(20),
                  const Divider(),
                  const Gap(10),

                  (userModel?.visa == null || userModel!.visa!.isEmpty)
                      ? CustomUserTextField(
                    controller: _visa,
                    label: "ADD VISA CARD",
                    textInputType: TextInputType.number,
                  )
                      : ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 16,
                    ),
                    tileColor: const Color(0xffF3F4F6),
                    leading: Image.asset(
                      "assets/test/image 13.png",
                      width: 50,
                    ),
                    title: CustomText(
                      text: "Debit Card",
                      color: Colors.black,
                    ),
                    subtitle: CustomText(
                      text: userModel?.visa ?? "",
                      color: Colors.black,
                    ),
                    trailing: CustomText(
                      text: "Default",
                      color: Colors.black,
                    ),
                  ),

                  const Gap(400),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade800,
                blurRadius: 20,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: updateProfileData,
                  child: isLoading
                      ? const CupertinoActivityIndicator()
                      : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomText(
                          text: "Edit Profile",
                          color: Colors.white,
                        ),
                        const Gap(5),
                        const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: isLogoutLoading ? null : logout,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        isLogoutLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CupertinoActivityIndicator(),
                        )
                            : const Icon(
                          Icons.logout,
                          color: Colors.green,
                        ),
                        const Gap(5),
                        CustomText(
                          text: isLogoutLoading ? "Logging out..." : "Logout",
                          color: AppColors.primary,
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