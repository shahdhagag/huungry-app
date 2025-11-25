import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';
import 'package:hungry_app/features/home/data/Models/topping_model.dart';
import 'package:hungry_app/features/home/data/Repo/productRepo.dart';
import 'package:hungry_app/features/product/widgets/spicy_slider.dart';
import 'package:hungry_app/features/product/widgets/topping_card.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../shared/custom_btn.dart';

class ProductDetailesView extends StatefulWidget {
  const ProductDetailesView({super.key, required this.productImage, required this.productId, required this.productPrice});

  final String productImage;
  final int productId;
 final String productPrice;
  @override
  State<ProductDetailesView> createState() => _ProductDetailesViewState();
}

class _ProductDetailesViewState extends State<ProductDetailesView> {
  double value =.5;
  List<int> selectedToppings =[];
  List<int> selectedOptions =[];


  List<ToppingModel>?toppings;
  List<ToppingModel>?sideOptions;

///product functions
  ProductRepo productRepo=ProductRepo();
  Future<void> getToppings ()async{
    final res =await productRepo.getToppings();

    setState(() {
     toppings=res;
    });
  }
  Future<void> getSideOptions ()async{
    final res =await productRepo.getSideOptions();

    setState(() {
      sideOptions=res;
    });
  }

  /// cart function

  CartRepo cartRepo=CartRepo();




  @override
  void initState() {
    getToppings();
    getSideOptions();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled:widget.productImage.isEmpty ,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white38,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);

            },
              child: Icon(Icons.arrow_back)),


        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpicySlider(
                  img: widget.productImage,
                value: value,
                onChanged: (v) {
                  setState(() {
                    value =v;
                  });
                },

                ),

                ///toppings
                CustomText(text: "Toppings", size: 20,weight: FontWeight.w600,),
                Gap(50),



                SingleChildScrollView(
                  clipBehavior: Clip.none
                  ,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(toppings?.length??4, (index){
                      final topping =toppings?[index];
                      final id =topping?.id??1;
                      if(topping==null){
                        return CupertinoActivityIndicator();
                      }

                      final isSelected=selectedToppings.contains(id);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ToppingCard(
                          color: isSelected ? Colors.green:Colors.white,
                            imageUrl:topping.image,
                            title: topping.name,
                            onAdd: (){
                            setState(() {
                              if(isSelected){
                                selectedToppings.remove(id!);
                              }else{
                                selectedToppings.add(id!);
                              }
                            });
                            },
                        ),
                      );
                    })
                  ),
                ),


                Gap(20),
                ///side options
                CustomText(text: "Side options", size: 20,weight: FontWeight.w600,),
                Gap(50),

                SingleChildScrollView(
                  clipBehavior: Clip.none
                  ,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(sideOptions?.length??4, (index){
                     //   final isSelected =selectedOptions ==index;
                        final sideOption =sideOptions?[index];
                        final id =sideOption?.id??1;
                        if(sideOption==null){
                          return CupertinoActivityIndicator();
                        }
                       final isSelected=selectedOptions.contains(id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),

                          child: ToppingCard(
                              color: isSelected ? Colors.green:Colors.white,
                              imageUrl: sideOption.image,
                              title: sideOption.name,
                            onAdd: (){
                              setState(() {
                                if(isSelected){
                                  selectedOptions.remove(id!);
                                }else{
                                  selectedOptions.add(id!);
                                }
                              });


                            },
                        ));
                      })
                  ),
                ),

                Gap(120),
              ],

            ),
          ),
        ),
        bottomSheet: Container(
          height: 120,
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
          child:              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Total" , size: 20,),

                    CustomText(text: "\$ ${widget.productPrice}"??"0.0" , size: 27,),
                  ],
                ),
                CustomBtn(
                  height: 45,
                  color: Colors.red,
                  widget: Icon(CupertinoIcons.cart_badge_plus, color: Colors.white),
                  text: 'Add To Cart',
                  onTap: () async {
                    final cartItem = CartModel(
                      productId: widget.productId,
                      quantity: 1,
                      spicy: value,
                      toppings: selectedToppings,
                      sideOptions: selectedOptions,
                    );

                    try {
                      final res = await cartRepo.addToCart(CartRequestModel(items: [cartItem]));

                      // Show success only if API call returns without exception
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to cart successfully"),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 130, left: 20, right: 20),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error adding to cart: ${e.toString()}"),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 130, left: 20, right: 20),
                        ),
                      );
                    }

                  },

                )

              ],
            ),
          ),

        ),
      ),
    );
  }
}
