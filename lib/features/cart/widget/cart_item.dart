import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';


class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.description,
    this.onAdd,
    this.onMin,
    this.onRemove,
    required this.number, required this.isLoading});

  final String image , text, description;
  final int number;
final  bool isLoading;



  final Function()? onAdd;
  final Function()? onMin;
  final Function()? onRemove;



  @override
  Widget build(BuildContext context) {
    return   Card(
      color: Colors.white,
      child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.network(image,
                  width:100,
                ),
                //CustomText(maxLines: 2,text: text,weight: FontWeight.bold,),
                Text(text.replaceAll(' Burger', '\nBurger'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                ),),
                CustomText(text:description),



              ],
            ),

            Column(
              children: [

                Row(
                  children: [

                    GestureDetector(
                      onTap:onAdd,
                      child: CircleAvatar(

                        backgroundColor: AppColors.primary, // circle color


                        child: Icon(CupertinoIcons.add,color: Colors.white,),
                      ),
                    ),
                    Gap(20),
                    CustomText(text: number.toString() ,weight: FontWeight.w500, size: 20,),
                    Gap(20),

                    GestureDetector(
                      onTap:onMin,
                      child: CircleAvatar(

                        backgroundColor: AppColors.primary, // circle color


                        child: Icon(CupertinoIcons.minus,color: Colors.white,),
                      ),
                    ),



                  ],
                ),

                Gap(20),

                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    height: 45,
                    width: 130,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                    isLoading?
                    CupertinoActivityIndicator(color: Colors.white,)
                        :Center(
                      child: CustomText(
                        text: "Remove",
                        color: Colors.white,
                      ),
                    ),
                  ),
                )










              ],
            )


          ],
        ),
      )
      ,

    );
  }
}
