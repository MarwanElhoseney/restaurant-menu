import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/utils/pref_helper.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/view/login_view.dart';
import 'package:restaurant_app/root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthRepo authRepo = AuthRepo();

  Future<void> _checkLogin() async {
    try {
      final token = await PrefHelper.getToken();
      final user = await authRepo.autoLogin();

      if (!mounted) return;

      // Guest Mode
      if (token == "guest") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      }
      // Logged in user
      else if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      }
      // No login
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => LoginView()),
        );
      }
    } catch (e) {
      print("Splash error: ${e.toString()}");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => LoginView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(200),
            SvgPicture.asset("assets/logo/logo.svg"),
            const Spacer(),
            Image.asset("assets/splash/splash.png"),
          ],
        ),
      ),
    );
  }
}