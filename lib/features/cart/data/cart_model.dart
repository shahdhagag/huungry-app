
class CartModel{

 final int productId;
 final int quantity;
 final double spicy;
 final List<int> toppings;
 final List<int> sideOptions;


CartModel({
   required this.productId,
   required this.quantity,
   required this.spicy,
   required this.toppings,
    required this.sideOptions,
 });


Map<String,dynamic>toJson()=>{

  "product_id": productId,
  "quantity":quantity,
  "spicy"   : spicy,
  "toppings": toppings,
  "side_options": sideOptions,


};

}



class CartRequestModel{


final  List<CartModel>items;

CartRequestModel({required this.items});

Map<String,dynamic> toJson()=>{
  "items":items.map((e)=>e.toJson() ).toList(),
};
}


class GetCartResponse {
  final int code;
  final String message;
  final CartData cartData;

  GetCartResponse({
    required this.code,
    required this.message,
    required this.cartData,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
      code: json["code"]??200,
      message: json["message"]?.toString()??"",
      cartData: CartData.fromJson(json["data"]),
    );
  }
}

class CartData {
  final int id;
  final String totalPrice;
  final List<CartItemModel> items;

  CartData({
    required this.id,
    required this.totalPrice,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    var itemsList = json["items"] as List;
    List<CartItemModel> cartItems = itemsList.map((i) => CartItemModel.fromJson(i)).toList();

    return CartData(
      id: json["id"]??0,
      totalPrice: json["total_price"]?.toString()??"0",
      items: cartItems,
    );
  }
}

class CartItemModel {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final double spicy;
  // final List<Topping> toppings;
  // final List<dynamic> sideOptions; // Keep as dynamic if structure is unknown

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.spicy,
    // required this.toppings,
    // required this.sideOptions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // var toppingsList = json["toppings"] as List;
    // List<Topping> toppings = toppingsList.map((t) => Topping.fromJson(t)).toList();

    return CartItemModel(
      itemId: json["item_id"]??0,
      productId: json["product_id"]??0,
      name: json["name"]??"",
      image: json["image"]??"",
      quantity: json["quantity"]??0,
      price: json["price"]??0,
      spicy: double.tryParse(json["spicy"].toString())??0.0,
      // toppings: toppings,
      // sideOptions: json["side_options"],
    );
  }
}
//
// class Topping {
//   final int id;
//   final String name;
//   final String image;
//
//   Topping({
//     required this.id,
//     required this.name,
//     required this.image,
//   });
//
//   factory Topping.fromJson(Map<String, dynamic> json) {
//     return Topping(
//       id: json["id"],
//       name: json["name"],
//       image: json["image"],
//     );
//   }
// }
//



