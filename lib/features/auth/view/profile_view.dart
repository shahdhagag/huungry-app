import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';
import 'package:hungry_app/features/auth/view/login_view.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/features/auth/widgets/custom_user_textfield.dart';
import 'package:hungry_app/shared/custom_btn.dart';
import 'package:hungry_app/shared/custom_snakebar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/custom_text.dart';

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

  bool isGuest = false;

  UserModel? userModel;
  String? selectedImage;
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    setState(() {
      isGuest = authRepo.isGuest;
      userModel = user;
    });
    if (user != null) {
      setState(() {
        userModel = user;
      });
    }
  }

  /// get profile
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
      ScaffoldMessenger.of(context).showSnackBar(customSnake(errorMsg));
    }
  }

  ///Update Profile

  Future<void> updateProfileData() async {
    try {
      setState(() => isLoading = true);

      final user = await authRepo.updateProfileData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        address: _address.text.trim(),
        visa: _visa.text.trim(),
        imagePath: selectedImage,
      );

      // Update local state
      setState(() {
        userModel = user;
        _name.text = user?.name ?? '';
        _email.text = user?.email ?? '';
        _address.text = user?.address ?? '';
        isLoading = false; // Stop loading
      });

      ScaffoldMessenger.of(context).showSnackBar(
        customSnake("Profile updated successfully"),
      );

    } catch (e) {
      setState(() => isLoading = false); // Stop loading on error
      String errorMsg = "Failed to update profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnake(errorMsg));
    }
  }

  ///Logout

  Future<void> logout() async {
    await authRepo.logout();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  /// pick image
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

  /////////////////////////////
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await autoLogin();

    if (!isGuest) {
      await getProfileData();
      setState(() {
        _name.text = userModel?.name ?? "";
        _email.text = userModel?.email ?? "";
        _address.text = userModel?.address ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isGuest) {
      return RefreshIndicator(
        onRefresh: () async {
          await getProfileData();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: AppColors.primary),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 0,
                  ),
                  child: SvgPicture.asset(
                    "assets/icon/settings.svg",
                    width: 20,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Skeletonizer(
                  enabled: userModel == null,
                  child: Column(
                    children: [
                      /// image
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: AppColors.primary,
                            ),
                            color: Colors.grey.shade300,
                            image: selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(File(selectedImage!)),
                                    fit: BoxFit.cover,
                                  )
                                : (userModel?.image != null &&
                                          userModel!.image!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            userModel!.image!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null), // Optional: use null or placeholder color
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
                                  errorBuilder: (context, err, builder) =>
                                      Icon(Icons.person),
                                )
                              : Icon(Icons.person),
                        ),
                      ),

                      Gap(30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // --- UPLOAD IMAGE button (BLUE) ---
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Gap(6),
                                  Text(
                                    "Upload",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Gap(20),

                          // --- REMOVE IMAGE button (RED) ---
                          if (selectedImage != null ||
                              (userModel?.image != null &&
                                  userModel!.image!.isNotEmpty))
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage =
                                      null; // ONLY remove the local selected image
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Gap(6),
                                    Text(
                                      "Remove",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                      Gap(20),

                      ///form
                      CustomUserTextfield(controller: _name, label: "Name"),
                      Gap(25),
                      CustomUserTextfield(controller: _email, label: "Email"),
                      Gap(25),
                      CustomUserTextfield(
                        controller: _address,
                        label: "Address",
                      ),
                      Gap(25),
                      Divider(),
                      Gap(10),

                      userModel?.visa == null
                          ? CustomUserTextfield(
                              controller: _visa,
                              label: "Add Visa Card",
                              textInputType: TextInputType.number,
                            )
                          : ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              tileColor: Color(0xffF3F4F6),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 16,
                              ),
                              leading: Image.asset(
                                "assets/icon/profileVisa.png",
                                width: 50,
                              ),
                              title: CustomText(
                                text: "Debit card",
                                color: Colors.black,
                              ),
                              subtitle: CustomText(
                                text: userModel?.visa ?? "**** *** 2345",
                                color: Colors.black,
                                size: 14,
                              ),
                              trailing: CustomText(
                                text: "Default",
                                color: Colors.black,
                              ),
                            ),

                      Gap(25),

                      Gap(200),
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
                  BoxShadow(color: Colors.grey.shade800, blurRadius: 20),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ///Edit button
                    isLoading
                        ? CupertinoActivityIndicator()
                        : GestureDetector(
                            onTap: updateProfileData,
                            child: Container(
                              padding: EdgeInsets.symmetric(
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
                                  Gap(5),
                                  Icon(
                                    CupertinoIcons.pencil,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),

                    ///LogOut
                    GestureDetector(
                      onTap: logout,
                      child: Container(
                        padding: EdgeInsets.symmetric(
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginView(),
                                  ),
                                );
                              },
                              child: CustomText(
                                text: "Logout",
                                color: AppColors.primary,
                              ),
                            ),
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
        ),
      );
    } else if (isGuest) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 90, color: AppColors.primary),

                SizedBox(height: 20),

                Text(
                  "You are in Guest Mode",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Please login or create an account to view and edit your profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

                SizedBox(height: 40),

                // --- LOGIN BUTTON ---
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginView()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // --- CREATE ACCOUNT BUTTON ---
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupView()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
    return SizedBox();
  }
}
