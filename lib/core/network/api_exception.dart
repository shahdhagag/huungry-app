import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {

    final statusCode =error.response?.statusCode;
    final data = error.response?.data;

    if(data is Map<String,dynamic> && data["message"]!=null){
      return ApiError(message: data["message"],statusCode: statusCode);

    }
    if(statusCode==302){
      throw ApiError(message: "This Email Already Taken");
    }
    ///condition


     print(statusCode);
    print(data);

    switch (error.type) {

      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Connection timeout. Please check your internet.");

      case DioExceptionType.sendTimeout:
        return ApiError(message: "Send timeout. Please try again.");

      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Receive timeout. Server is too slow.");

      case DioExceptionType.badCertificate:
        return ApiError(message: "Bad certificate. Unsafe connection.");

      case DioExceptionType.cancel:
        return ApiError(message: "Request cancelled.");

      case DioExceptionType.connectionError:
        return ApiError(message: "Network error. No internet connection.");

      case DioExceptionType.unknown:
        return ApiError(message: "Something went wrong. Try again later.");


      case DioExceptionType.badResponse:

        return ApiError(message: "Bad Response. Try again later.");
    }
  }


}
