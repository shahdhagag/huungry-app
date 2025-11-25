import 'package:flutter/cupertino.dart';

class ProductModel{

  int id;
  String name;
  String description;
  String image;
  String rating;
  String price;


 ProductModel(
  {
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
  }
     );

 factory ProductModel.fromJson(Map<String,dynamic>json){

   return  ProductModel(
       id: json["id"],
       name: json["name"],
       description: json["description"],
       image: json["image"],
       rating: json["rating"],
       price:json["price"]
   );





 }


}
