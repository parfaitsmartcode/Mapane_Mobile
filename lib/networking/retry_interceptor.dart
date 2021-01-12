import 'package:dio/dio.dart';

class RetryOnAuthFailInterceptor extends Interceptor{

  @override
  Future onError(DioError err) async {
    if(_shouldRefresh(err)){
      // TODO: implement onError

    }
    return err;
  }
  bool _shouldRefresh(DioError err){
    return err.response.statusCode == 401;
  }
}