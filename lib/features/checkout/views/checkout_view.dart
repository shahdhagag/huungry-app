import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/checkout/widgets/order_detailes_widget.dart';
import 'package:hungry_app/features/checkout/widgets/success_dailog.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error.dart';
import '../../../shared/custom_btn.dart';
import '../../../shared/custom_snakebar.dart';
import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.totalPrice});
  final String totalPrice;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedMethod = "cash";
  bool isLoading = true;
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;


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
  @override
  void setState(VoidCallback fn) {
isLoading=false;
super.setState(fn);
  }
@override
  void initState() {
  getProfileData();
  super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Order Summary",
                size: 20,
                weight: FontWeight.w500,
              ),

              Gap(10),
              OrderDetailesWidget(
                order: widget.totalPrice??"16.39",
                taxes: "3.50",
                fees: " 40.33",
                total: (double.parse(widget.totalPrice)+3.50+40.33).toStringAsFixed(2),
              ),

              Gap(80),
              CustomText(
                text: "Payment methods",
                size: 20,
                weight: FontWeight.w500,
              ),
              Gap(15),

              ListTile(
                onTap: () => setState(() => selectedMethod = "cash"),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Color(0xff3C2F2F),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                leading: Image.asset("assets/icon/dollar.png", width: 50),
                title: CustomText(
                  text: "cash on Delivery",
                  color: Colors.white,
                ),
                trailing: Radio<String>(
                  value: "cash",
                  activeColor: Colors.white,
                  groupValue: selectedMethod,
                  onChanged: (v) => setState(() => selectedMethod = v!),
                ),
              ),
              Gap(10),
             ///visa
              isLoading
                  ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              )
                  : userModel?.visa == null
                  ? SizedBox.shrink()
             : ListTile(
                onTap: () => setState(() => selectedMethod = "Visa"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.blue.shade900,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 16,
                ),
                leading: Image.asset("assets/icon/visa.png", width: 50),
                title: CustomText(text: "Debit card", color: Colors.white),
                subtitle: CustomText(
                  text: userModel?.visa??
                  "**** **** 2346",
                  color: Colors.white,
                ),
                trailing: Radio<String>(
                  value: "Visa",
                  activeColor: Colors.white,
                  groupValue: selectedMethod,
                  onChanged: (v) => setState(() => selectedMethod = v!),
                ),
              ),

              Gap(5),
              Row(
                children: [
                  Checkbox(
                    activeColor: Color(0xffEF2A39),
                    value: true,
                    onChanged: (v) {},
                  ),
                  CustomText(text: "Save card details for future payments"),
                ],
              ),
              Gap(200),
            ],
          ),
        ),
      ),

      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 15,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Total", size: 15),
                CustomText(text:(double.parse(widget.totalPrice)+3.50+40.33).toStringAsFixed(2), size: 24),
              ],
            ),
            CustomBtn(
              text: 'Pay Now',
              // width: 100,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (builder) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 200,
                          horizontal: 20,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade800,
                                blurRadius: 15,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.primary,
                                child: Icon(
                                  CupertinoIcons.check_mark,
                                  color: Colors.white,
                                ),
                              ),
                              Gap(10),
                              CustomText(
                                text: "success!",
                                color: AppColors.primary,
                                weight: FontWeight.bold,
                                size: 20,
                              ),
                              Gap(3),

                              CustomText(
                                text:
                                    "  Your payment was successful\nA receipt for this purchase\n has been sent to your email.",
                                color: Colors.grey.shade400,

                                size: 10,
                              ),
                              Gap(10),

                              CustomBtn(
                                text: "Close",
                                width: 200,
                                onTap: () {
                                  Navigator.pop(context); // close the dialog
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
