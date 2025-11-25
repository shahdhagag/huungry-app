import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_textfield.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';

import '../../../shared/custom_btn.dart' hide CustomBtn;

import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/shared/custom_text.dart';

import '../../../shared/custom_snakebar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading=false;


  AuthRepo authRepo = AuthRepo();

  Future<void> login() async {

    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading=true;
      });
      try {
        final user = await authRepo.login(
          emailController.text.trim(),
          passController.text.trim(),
        );
        if (user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => Root()));
        }
        setState(() {
          isLoading=false;
        });
    }catch (e) {
        setState(() {
          isLoading=false;
        });
      String errorMsg = "unhandled error in login";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context,).showSnackBar(customSnake(errorMsg));
    }
  }}

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   emailController.text="Sonic44@gmail.com";
  //   passController.text="123456789333";
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

      child: PopScope(
        canPop: false,
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Center(
            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  Gap(100),
                  SvgPicture.asset(
                    "assets/logo/logo_.svg",
                    color: AppColors.primary,
                  ),
                  Gap(10),

                  CustomText(
                    text: "Welcome back, Discover the best food",
                    color: AppColors.primary,
                    weight: FontWeight.w600,
                    size: 13,
                  ),
                  Gap(50),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),

                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Gap(30),

                            CustomTextfield(
                              hint: "Email Address",
                              isPassword: false,
                              controller: emailController,
                            ),

                            Gap(15),
                            CustomTextfield(
                              hint: "Password",
                              isPassword: true,
                              controller: passController,
                            ),

                            Gap(30),
                             ///Login Button
                            isLoading ?CupertinoActivityIndicator(color: Colors.white,)
                            :CustomBtn(
                              text: "Login",
                              textColor: Colors.white,
                              color: AppColors.primary,
                              onTap: login,
                            ),

                            Gap(30),

                            ///go to sign up
                            CustomBtn(
                              textColor: AppColors.primary,
                              color: Colors.white,
                              text: "Create Account ?",
                              onTap: () {
                                Navigator.pushReplacement(
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

                            ///Guest
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
                                text: "Continue as a Guest ?",
                                color: Colors.orange,
                                size: 13,
                                weight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }
}
