import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'custom_text.dart';
class CustomBtn extends StatelessWidget {
  const CustomBtn({super.key, required this.text, this.onTap, this.width, this.height, this.color, this.radius, this.widget});
  final String text;
  final double ? width;
  final double ? height;
  final Color ? color;
  final Function()? onTap;
  final double ? radius;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return    GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        //color: color ?? AppColors.primary,

        padding : EdgeInsets.symmetric(horizontal: 20, vertical: 15
        ),

        decoration: BoxDecoration(
          color: color != null?color:AppColors.primary,
          borderRadius: BorderRadius.circular(radius??18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            CustomText(text: text, color: Colors.white,),
            if (widget != null) SizedBox(width: 8),
            if (widget != null) widget!,


          ],
        ),
      ),
    )
    ;
  }
}
