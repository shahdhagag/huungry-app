import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/home/data/Models/productModel.dart';
import 'package:hungry_app/features/home/data/Models/topping_model.dart';

class ProductRepo{
  ApiService _apiService = ApiService();

  ///Get Products

  Future<List<ProductModel>> getProducts()async{

    try{
      final response =await _apiService.get("/products");

      return (response["data"] as List)
          .map((product)=> ProductModel.fromJson(product))
          .toList();


    }catch(e){
      print(e.toString());
      return [];
    }


  }

 ///get topping

 Future<List<ToppingModel>> getToppings()async{
    
    
    try{
      final response = await ApiService().get("/toppings");
      return (response["data"] as List)
          .map((topping)=>ToppingModel.fromJson(topping))
          .toList();
    }catch(e){
      print(e.toString());
      return [];
      
    }
    
 }
 ///option Side

  Future<List<ToppingModel>> getSideOptions()async{


    try{
      final response = await ApiService().get("/side-options");
      return (response["data"] as List)
          .map((e)=>ToppingModel.fromJson(e))
          .toList();
    }catch(e){
      print(e.toString());
      return [];

    }

  }
  ///search




  Future<List<ProductModel>> searchProducts(String name)async{

    try{
      final response =await _apiService.get("/products",param: {"name":name});

      return (response["data"] as List)
          .map((product)=> ProductModel.fromJson(product))
          .toList();
    }catch(e){
      print(e.toString());
      return [];
    }


  }










///category
}