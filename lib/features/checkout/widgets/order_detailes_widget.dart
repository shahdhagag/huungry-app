import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../shared/custom_text.dart';
import '../views/checkout_view.dart';

class OrderDetailesWidget extends StatelessWidget {
  const OrderDetailesWidget({super.key, required this.order, required this.taxes, required this.fees, required this.total});

  final String order,taxes,fees,total;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        checkOutWidget("Order",order, false,false),
        Gap(10),
        checkOutWidget("Taxes", taxes,false,false),
        Gap(10),
        checkOutWidget("Delivery fees", fees, false,false),

        Gap(10),
        Divider(),
        Gap(10),

        checkOutWidget("Total:", total, true,false),
        Gap(10),
        checkOutWidget("Estimated delivery time:", "15 - 30 min", true,true),

      ],
    );
  }
}


Widget checkOutWidget (title , price, isbold, issmall){
  return             Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(text: title,
        size: issmall ?12 : 15,
        weight: isbold? FontWeight.bold :FontWeight.w400,
        color: isbold ? Colors.black : Colors.grey.shade600,

      ),
      CustomText(text: "\$$price",
        size: issmall ?13 : 15,
        weight: isbold? FontWeight.bold :FontWeight.w400,
        color: isbold ? Colors.black : Colors.grey.shade600,


      ),


    ],
  );


}
