import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/view/login_view.dart';
import 'package:restaurant_app/root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  AuthRepo authRepo = AuthRepo();

  Future<void> _checkLogin() async {
    try {
      final user = await authRepo.autoLogin();
      if (!mounted) return;
      if (authRepo.isGuest) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => Root()));
      }
      else if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => Root()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => LoginView()));
      }
    } catch (e) {
      print("splash error:4${e.toString()}");
    }
  }
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), _checkLogin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gap(200),
            SvgPicture.asset("assets/logo/logo.svg"),
            Spacer(),
            Image.asset("assets/splash/splash.png"),
          ],
        ),
      ),
    );
  }
}
