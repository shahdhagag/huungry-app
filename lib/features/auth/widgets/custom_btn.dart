import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    this.onTap,
    required this.text,   this.width, this.color, this.textColor, this.widget});
  final Function() ? onTap;
  final String text;
  final double ? width;
  final Color ? color;
  final Color ? textColor;
  final Widget?widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 50,
        width: width,

        decoration: BoxDecoration(
          border: Border.all(

            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(7),
          color: color ?? Colors.white,
        ),
     //   width: 200,

        child: Center(
          child: CustomText(
            text: text,
            size: 15,
            weight: FontWeight.w700,
            color: textColor??AppColors.primary,


          ),
        ),
      ),
    );
    ;
  }
}
