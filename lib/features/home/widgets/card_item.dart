import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';

import '../../../shared/custom_text.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.image,
    required this.text,
    required this.description,
    required this.rate});

  final String image , text, description, rate;


  @override
  Widget build(BuildContext context) {
    return

      Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              width: 130,
              height: 120
              ,),
            Gap(10),
            CustomText(text: text ,weight:  FontWeight.bold,),
            CustomText(text: description),
            Row(
              children: [
                CustomText(text: "⭐ $rate"),
                Spacer(),
                Icon(CupertinoIcons.heart_fill, color: AppColors.primary,)
              ],
            ) ,


          ],
        ),
      ),

    )
    ;
  }
}
