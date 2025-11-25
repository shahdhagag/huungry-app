import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomUserTextfield extends StatelessWidget {
  const CustomUserTextfield({super.key, required this.controller, required this.label, this.textInputType});

  final TextEditingController controller;
  final String label;
 final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return    TextField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColors.primary,
      cursorHeight: 20,
      style: TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        contentPadding:EdgeInsets.symmetric(horizontal: 20) ,
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primary),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    )
    ;
  }
}
