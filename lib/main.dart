import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/cubit/auth_cubit.dart';
import 'package:restaurant_app/features/cart/cubit/cart_cubit.dart';
import 'package:restaurant_app/features/home/cubit/home_cubit.dart';
import 'package:restaurant_app/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()..getProducts()),
        BlocProvider(create: (_) => CartCubit()..getCartData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        theme: ThemeData(
          splashColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashView(),
      ),
    );
  }
}
