import 'package:dio/dio.dart';
import 'package:near_me/models/user.dart';
import 'package:near_me/utils/n_exception.dart';
import '../../di.dart';
import '../../service_locator.dart';

class UserService {
  Future<User> updateHouse() async {
    try{
      final String uri = locator<Di>().apiUrl + "/categories";
      Response response = await locator<Di>().dio.get(
          uri,
          options: Options(headers: {"content-type": "application/json"})
      );
      final items = response.data["categories"].cast<Map<String,dynamic>>();
      User categories = items.map<User>((json){
        return User.fromJson(json);
      });
      return categories;
    } on DioError catch (e) {
      throw new NException(e);
    }
  }
}

final UserService userService = UserService();
