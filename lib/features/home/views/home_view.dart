import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/home/widgets/card_item.dart';
import 'package:hungry_app/features/home/widgets/search_field.dart';
import 'package:hungry_app/features/home/widgets/user_header.dart';
import 'package:hungry_app/features/home/data/Models/productModel.dart';
import 'package:hungry_app/features/home/data/Repo/productRepo.dart';
import 'package:hungry_app/features/product/views/product_detailes_view.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/network/api_error.dart';
import '../../../shared/custom_snakebar.dart';
import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../widgets/food_category.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ["All", "Combos", "Sliders", "Classic"];
  int selectedIndex = 0;
final TextEditingController controller=TextEditingController();

  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;


  /// get profile
  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      print("🔍 USER IMAGE URL: ${user?.image}");
      print("🔍 USER NAME: ${user?.name}");
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = "Error in profile";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnake(errorMsg));
    }
  }


List<ProductModel>?products;
  List<ProductModel>?allProducts;

  ProductRepo productRepo=ProductRepo();

  Future<void> getProducts ()async{
    final res =await productRepo.getProducts();

    setState(() {
      allProducts=res;
      products=res;
    });
  }

  @override
  void initState() {
    getProfileData();
    getProducts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Skeletonizer(
        enabled: products==null,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [

              /// ///header
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  floating: false,
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.white,
                  toolbarHeight: 160,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Padding(
                      padding: const EdgeInsets.only(top: 30 , right:20, left: 20),
                    child: Column(
                      children: [
                        UserHeader(
                          userName: userModel?.name??"User",
                          userImage:userModel?.image??"https://i.pinimg.com/736x/16/18/20/1618201e616f4a40928c403f222d7562.jpg" ,
                        ),
                        Gap(20),
                        SearchField(
                          controller: controller,
                          onChanged: (value){

                            final query  =value.toLowerCase();

                            setState(() {
                              products=allProducts?.where((p)=>p.name.toLowerCase().contains(query)).toList();
                            });

                          },


                        ),
                      ],
                    ),
                  ),
                ),


                 /// search + Category

                 SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        /// category
                        FoodCategory(selectedIndex: selectedIndex, category: category,)
                    ,
                    ),
                  ),



              /// GridView

              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 14,vertical: 14),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: products?.length,
                        (context, index) {
                      final product=products?[index];

                      if(product==null){
                        return CupertinoActivityIndicator();
                      }

                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (c){
                            try {
                            } on Exception catch (e, s) {
                              print(s);
                            }
                            return ProductDetailesView(
                              productImage: product.image,
                              productId: product.id,
                              productPrice:product.price,

                            );
                          }));
                        },
                        child: CardItem(
                          image: product.image,
                          text: product.name,
                          description: product.description,
                          rate: product.rating,
                        ),
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
