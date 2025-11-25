import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_exception.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';

class CartRepo{
 ///add to cart
  Future<void> addToCart(CartRequestModel cartData)async{
    ApiService _apiService = ApiService();

    try{
      final res= await _apiService.post("/cart/add", cartData.toJson());
      throw ApiError(message: "Product Added Successfully to cart");
    }catch(e){

      throw ApiError(message: e.toString());
    }


  }

 ///get cart





  Future<GetCartResponse?> getCartData()async{
    ApiService _apiService = ApiService();

    try{
      final res= await _apiService.get("/cart");
      if( res is ApiError){
        throw ApiError(message: res.toString());      }

      return GetCartResponse.fromJson(res);
    }catch(e){

      throw ApiError(message: e.toString());
    }


  }






///remove cart item

Future<void> removeCartItem(int id)async{
  final ApiService _apiService = ApiService();

  try{
    final res= await _apiService.delete("/cart/remove/$id",{},);
    if(res["code"]==200&& res["data"]==null){
      throw ApiError(message: res["message"]);
    }
  }catch(e){
    throw ApiError(message: "Remove Item From Cart:${e.toString()}");
  }
}}
