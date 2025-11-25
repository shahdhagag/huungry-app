import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key, required this.userName, required this.userImage});
  final String userName,userImage;


  @override
  Widget build(BuildContext context) {
    return                     Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SvgPicture.network(userImage??
            //   "assets/logo/logo_.svg",
            //   color: AppColors.primary,
            //   height: 36,
            // ),
           // Gap(3),
            Row(
              children: [
                CustomText(
                  text: "Hello, ",
                  size: 16,
                  weight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                CustomText(
                  text: userName??"Hello, Shahd Ahmed",
                  size: 16,
                  weight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ],
            ),

            /// Subtitle
            CustomText(
              text: "Hungry Today?",
              size: 14,
              weight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),

          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
              radius: 35,
            backgroundColor:  AppColors.primary,
            child:
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                    child: Image.network(

                        userImage,
                      errorBuilder: (context,err,builder)=>Icon(Icons.person,color: Colors.white,),
                    )),

                    //Icon(CupertinoIcons.person, color: Colors.white,),backgroundColor: AppColors.primary,
          ),
        ),
      ],
    )   ;
  }
}
