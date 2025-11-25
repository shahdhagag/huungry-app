import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_exception.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/core/utils/pref_helper.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';


///Handles authentication-related actions
/// (login, register, logout, get/update profile).
/// Uses ApiService to talk to the server
/// and PrefHelper to store the token.

class AuthRepo{
  ApiService apiService=ApiService();
  bool isGuest=false;
  UserModel?_currentUser;

  ///login

Future<UserModel?> login( String email, String password) async{
   try {
///Call the API → sends email/password to /login endpoint.
     final response = await apiService.post("/login", {"email":email ,"password":password});

     if(response is ApiError){
       throw response;
     }
     if(response is Map<String,dynamic>){
       final msg = response["message"];
       final code = response["code"];
       final data = response["data"];
       if(code!=200 || data==null){
         throw ApiError(message: msg);
       }
       ///Parse response → converts JSON from server → UserModel.
       final user =UserModel.fromJson(response["data"]);
       if(user.token!=null){
         await PrefHelper.saveToken(user.token!);
       }
       isGuest=false;
       _currentUser=user;

       return user;


     }else{
       throw ApiError(message: "unExpected error from server");
     }


   } on DioError catch(e){
     throw ApiExceptions.handleError(e);
   }catch(e){
     throw ApiError(message: e.toString());
   }
}





///Sign Up

Future<UserModel?> signup(String name ,String email, String password)async{
  try{
   final response= await apiService.post("/register", {"name":name, "password":password, "email":email});

   if(response is ApiError){
     throw response;
   }

   if(response is Map<String,dynamic>){
     // Handle email already taken
     if (response["errors"]?["email"] != null) {
       final emailErrors = response["errors"]["email"];
       if (emailErrors is List && emailErrors.isNotEmpty) {
         throw ApiError(message: emailErrors[0]);
       }
     }

     // // 🟢 CHECK FOR EMAIL ERROR HERE
     // if (response["errors"] != null) {
     //   final emailErrors = response["errors"]["email"];
     //
     //   if (emailErrors is List && emailErrors.isNotEmpty) {
     //     throw ApiError(message: emailErrors[0]);
     //   }
     // }



     final msg = response["message"];
     final code = response["code"];
     final coder =  int.tryParse(code);

     final data = response["data"];

      if(coder!=200 && coder!=201){
        throw ApiError(message: msg??"Unknown error");
      }
/// condition
      final user =UserModel.fromJson(data);
     print("User after signup: $user, token: ${user.token}");

     if(user.token != null){
        await PrefHelper.saveToken(user.token!);
      }
     isGuest=false;
     _currentUser=user;

      return user;

   }else{

     throw ApiError(message: "unexpected error from server");
   }

  }on DioError catch(e){
    throw ApiExceptions.handleError(e);

  }catch(e){
    throw ApiError(message: e.toString());
  }

}




///get profile data
Future<UserModel?> getProfileData ()async{


  try {
    final token = await PrefHelper.getToken();
    if (token == null || token == "guest") {
      return null;
    }

    final response = await apiService.get("/profile");

    final user = UserModel.fromJson(response["data"]);
    _currentUser = user;
    return user;

  }  on DioError catch(e){
    ApiExceptions.handleError(e);
  }catch(e){
    throw ApiError(message: e.toString());
  }

}


///Update Profile data

Future<UserModel?> updateProfileData({
    required String name,
    required String email,
    required String address,
     String ?visa,
    String ?imagePath

  }
    )async{

try{

  final formData =FormData.fromMap(
  {
  "email":email ,
  "name":name,
  "address":address,
    if(visa!=null&& visa.isNotEmpty)
  "Visa":visa,
    if(imagePath!=null&& imagePath.isNotEmpty)
      "image":await MultipartFile.fromFile(imagePath,filename: "profile.jpg"),
  }

  );
  final response = await apiService.post(
      "/update-profile",
        formData,
      );
  if(response is ApiError){
    throw response;
  }
  if(response is Map<String,dynamic>){
    final msg = response["message"];
    final code = response["code"];
    final data =response["data"];
    final coder =  int.tryParse(code);


    if(coder!=200 && coder!=201){
      throw ApiError(message: msg??"Unknown error");
    }
    final user=UserModel.fromJson(data);
    _currentUser=user;
    return user;
  }
    else{
      throw ApiError(message: "Invalid Error from here");
    }


}on DioError catch(e){
  throw ApiExceptions.handleError(e);
}catch (e){
  throw ApiError(message: e.toString());
}


}
///Logout

Future<void> logout()async{
  final response=await apiService.post("/logout", {});

  if(response["data"]!=null){
    throw ApiError(message: "erorrrrr");

  }
  await PrefHelper.clearToken();
  _currentUser=null;
  isGuest=true;
}


///auto login
Future<UserModel?> autoLogin()async{
  final token =await PrefHelper.getToken();
  if(token==null|| token=="guest"){
    _currentUser=null;
    isGuest=true;
    return null;

  }
  isGuest=false;


  try{
  final user =await getProfileData();
  _currentUser=user;
  isGuest=false;
  return user;
  }catch(e){
    await PrefHelper.clearToken();
    _currentUser=null;
    isGuest=true;
return null;
  }


}

/// continue as guest


Future<void> continueAsGuest()async{
  _currentUser=null;
  isGuest=true;
  await PrefHelper.saveToken("guest");
}

UserModel? get currentUser=>_currentUser;
bool get isLoggedIn=>!isGuest&&_currentUser !=null;



}

















