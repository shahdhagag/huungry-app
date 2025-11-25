import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exception.dart';
import 'package:hungry_app/core/network/dio_client.dart';

///ApiService (The “bridge” between UI and DioClient)
class ApiService{
  final DioClint _dioClint =DioClint();


  ///CRUD METHODS

  ///get

Future<dynamic> get(String endPoint,{dynamic param}) async{
  try{
    final response =await _dioClint.dio.get(endPoint ,queryParameters: param);
    return response.data;
  }on DioException catch(e){
    return ApiExceptions.handleError(e);
  }
}
/// post

  Future<dynamic> post(String endPoint,dynamic body) async{
    try{
      final response =await _dioClint.dio.post(endPoint,data: body );
      return response.data;
    }on DioException catch(e){
      return ApiExceptions.handleError(e);
    }
  }

///put//update

  Future<dynamic> put(String endPoint,dynamic body) async{
    try{
      final response =await _dioClint.dio.put(endPoint,data: body );
      return response.data;
    }on DioException catch(e){
      return ApiExceptions.handleError(e);
    }
  }

/// delete
  Future<dynamic> delete(String endPoint,dynamic body, {dynamic params}) async{
    try{
      final response =await _dioClint.dio.delete(endPoint,data: body,queryParameters: params );
      return response.data;
    }on DioException catch(e){
      return ApiExceptions.handleError(e);
    }
  }
}