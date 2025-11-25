import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'custom_text.dart'; // make sure CustomText is correctly imported

SnackBar customSnake(errorMsg){
  return           SnackBar(
      margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      backgroundColor:Colors.red,
      clipBehavior: Clip.none,
      content: Row(
        children: [
          Icon(CupertinoIcons.info,color: Colors.white,),
          Gap(14),
          Expanded(child: CustomText(text: errorMsg,color: Colors.white,size: 14,weight: FontWeight.w600,)),
        ],
      ));

}