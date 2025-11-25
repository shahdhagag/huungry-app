import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/view/login_view.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

AuthRepo authRepo=AuthRepo();
Future<void> _checkLogin()async{
  try{
    if(authRepo.isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Root()));

    }else if (authRepo.isGuest){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Root()));

    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginView()));

    }
  }catch(e){
    print("error from splash :${e.toString()}");
  }
}

@override
void initState() {
  super.initState();
  _initApp();
}

Future<void> _initApp() async {
  await authRepo.autoLogin();   // 🔥 مهم جداً
  Future.delayed(const Duration(seconds: 2), _checkLogin);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Logo from top
          TweenAnimationBuilder(
            tween: Tween<double>(begin: -200, end: 0),
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Positioned(
                top: value + 100, // adjust final position
                left: 0,
                right: 0,
                child: child!,
              );
            },
            child: Center(
              child: SvgPicture.asset("assets/logo/logo_.svg"),
            ),
          ),

          // Sandwich image from bottom
          TweenAnimationBuilder(
            tween: Tween<double>(begin: -200, end: 0),
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Positioned(
                bottom: value + 50, // adjust final position
                left: 0,
                right: 0,
                child: child!,
              );
            },
            child: Center(
              child: Image.asset("assets/splash/splash.png"),
            ),
          ),
        ],
      ),
    );
  }
}
