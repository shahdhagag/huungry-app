
///A simple model class
///that represents the error the backend sends to you.
class   ApiError{
final  int? statusCode;
final String message;

ApiError({required this.message, this.statusCode});



  @override
  String toString() {
    // TODO: implement toString
    return " $message";
  }

}