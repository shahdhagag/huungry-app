import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/view/login_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:hungry_app/shared/custom_textfield.dart';

import '../../../shared/custom_snakebar.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading =false;
  AuthRepo authRepo = AuthRepo();

  Future<void> signup() async{

 if(formKey.currentState!.validate()){
   try{
     setState(() {
        isLoading =true;
     });
     final user =await authRepo.signup(nameController.text.trim(), emailControler.text.trim(), passController.text.trim());

     if (user != null) {
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Root()));
     }
     setState(() {
       isLoading =false;

     });

   }catch(e){
     setState(() {
       isLoading =false;

     });
     String errMsg ="Error in register";
     if(e is ApiError){
       errMsg=e.message;
     }
     print("🔥 Backend error message: $errMsg");

     ScaffoldMessenger.of(context,).showSnackBar(customSnake(errMsg));

   }
 }

  }




  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Gap(100),
              SvgPicture.asset("assets/logo/logo_.svg", color: AppColors.primary),

              CustomText(text: "Welcome to our Food App"),
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
                          hint: "Name",
                          isPassword: false,
                          controller: nameController,
                        ),
                        Gap(20),
                        CustomTextfield(
                          hint: "Email",
                          isPassword: false,
                          controller: emailControler,
                        ),
                        Gap(20),
                        CustomTextfield(
                          hint: "Password",
                          isPassword: true,
                          controller: passController,
                        ),
                        Gap(30),
                        ///sign up
                        isLoading ?CupertinoActivityIndicator(color: Colors.white,):
                        CustomBtn(
                          text: "Sign up",
                          onTap:signup,
                        ),
                        Gap(20),

                        ///go to login
                        CustomBtn(
                          textColor: Colors.white,
                          color: Colors.transparent,
                          text: "Go To Login ?",
                          onTap: () {
                            Navigator.pushReplacement(
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
