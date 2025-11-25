// What it contains
//
// The Dio setup:
// base URL
// headers
// interceptors
// timeout settings
// adding token to headers

/// This file is the brain of Dio... it sets everything up.
/// Every time you call the API → it passes through api_client.



import 'package:dio/dio.dart';
import 'package:hungry_app/core/utils/pref_helper.dart';
class DioClint{
  ///instance of dio package
 final Dio _dio =Dio(
   BaseOptions(
     baseUrl: "https://sonic-zdi0.onrender.com/api",
     headers: {"Content-Type":"application/json"},

   )
 );


 /// Constructor
 /// Adds an interceptor to automatically add Authorization token
 /// or perform other actions before request is sent.
 DioClint(){





  _dio.interceptors.add(
    InterceptorsWrapper(
      /// Runs before every request
    onRequest: (options, handler)async {
        final token = await PrefHelper.getToken();
        if(token!=null && token.isNotEmpty&& token!="guest"){
          options.headers["Authorization"]="Bearer $token";
        }
        return handler.next(options);
      },
    )
  ) ;
 }

 /// Getter to expose Dio instance to other files
 /// Example usage: DioClient().dio.get("/users");
 Dio get dio => _dio;
}