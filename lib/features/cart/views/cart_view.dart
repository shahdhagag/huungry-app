import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/custom_btn.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';
import 'package:hungry_app/features/cart/widget/cart_item.dart';
import 'package:hungry_app/shared/custom_snakebar.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../../auth/view/login_view.dart';
import '../../auth/view/signup_view.dart';
import '../../checkout/views/checkout_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
 //final int itemCount =20;
  bool isLoading=false;
late   List<int> quantities=[] ;
GetCartResponse?cartResponse;
CartRepo cartRepo=CartRepo();
bool isLoadingRemove=false;


  bool isGuest=false;
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;
  Future<void> autoLogin() async{
    final user = await authRepo.autoLogin();
    setState(() {
      isGuest=authRepo.isGuest;
      userModel = user;
    });
    if(user!=null){
      setState(() {
        userModel=user;
      });

    }
  }
  Set<int> removingItems = {};

Future<void>getCartData()async{
  try{
    if(!mounted)return;
    setState(() {
      isLoading=true;
    });
    final res=await cartRepo.getCartData();
    if(!mounted)return;
    final itemCount=res?.cartData.items.length??0;
    setState(() {
      cartResponse=res;
      isLoading=false;
      quantities=List.generate(itemCount, (_)=>1);

    });

  }catch(e){
    if(!mounted)return;
    setState(() {
      isLoading=false;
      print(e.toString());
    });
  }
}



  Future<void> removeCartItem(int id) async {
    try {
      setState(() {
        removingItems.add(id); // mark this item as loading
        // Remove the item locally for instant UI update
        cartResponse?.cartData.items.removeWhere((item) => item.itemId == id);
        // Also remove quantity for that index
        // assuming quantities and cart items are aligned
        final index = quantities.length > 0
            ? cartResponse!.cartData.items.indexWhere((item) => item.itemId == id)
            : -1;
        if (index != -1) quantities.removeAt(index);
      });

      await cartRepo.removeCartItem(id);

      setState(() {
        removingItems.remove(id); // remove loading state
      });

    } catch (e) {
      setState(() {
        removingItems.remove(id);
      });
      print(e.toString());
    }
  }




@override
  void initState() {
  getCartData();
  autoLogin();
    // TODO: implement initState
    super.initState();
  }

void onAdd(int index){
     setState(() {

       quantities[index]++;
     });
   }

   void onMin(int index){
     setState(() {
       if(quantities[index]>1){
         quantities[index]--;
       }

     });
   }

  @override
  Widget build(BuildContext context) {
    if (!isGuest){
      return Skeletonizer(
      enabled:cartResponse==null ,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,scrolledUnderElevation: 0,backgroundColor: Colors.white,
        ),


        body:
            isLoading
          ?Center(child: CupertinoActivityIndicator())
          :Stack(
              clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 120),
                itemCount: cartResponse?.cartData.items.length,
                itemBuilder: (context, index) {
                  final item= cartResponse!.cartData.items[index];
                       // if(item==null){
                       //   return CupertinoActivityIndicator();
                       // }
                  return CartItem(
                    isLoading: removingItems.contains(item.itemId),
                    image: item.image,
                    text: item.name,
                    description: "Spicy ${item.spicy}",
                    number: quantities[index],
                    onRemove: (){
                      removeCartItem(item.itemId);
                    },

                    onAdd: ()=>onAdd(index),
                    onMin: ()=> onMin(index),
                  );
                },
              ),
            ),
          ],
        ),

        bottomSheet: Container(
          decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)

              ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade800, // shadow color
               // spreadRadius: 2, // how wide the shadow spreads
                blurRadius: 20, // how soft the shadow looks
                offset: Offset(0, 0),
              )
            ]
          ),

          padding: const EdgeInsets.all(10),
          height: 90,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Total", size: 15),
                  CustomText(text: "${cartResponse?.cartData.totalPrice}\$", size: 24),
                ],
              ),
              CustomBtn(
                  text: 'Checkout',
                  color: AppColors.primary,
                  textColor: Colors.grey,
                 // widget: CustomText(text: "${cartResponse?.cartData.totalPrice}\$"??"0.0",size: 14,),
                  width: 100,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_){
                      return CheckoutView(

                        totalPrice: cartResponse?.cartData.totalPrice.toString() ?? "0.0",
                      );
                    }
                    ));
                  },),
            ],
          ),
        ),
      ),
    );
    }else if (isGuest) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cart icon with lock
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade300),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(Icons.lock, size: 40, color: AppColors.primary),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Your Cart is Empty",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "You are currently in Guest Mode.\nLogin or create an account to start adding items to your cart.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 40),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupView()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      }
    return const SizedBox.shrink();
    }
  }
