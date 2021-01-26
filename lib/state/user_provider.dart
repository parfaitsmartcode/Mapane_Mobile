import 'package:dartz/dartz.dart';
import 'package:mapane/models/user.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapane/utils/shared_preference_helper.dart';
import 'base_provider.dart';



class UserProvider extends BaseProvider{
  // Either<NException,List<User>> alertList = Right([]);

  //stockage du domicile
  storeDomicile(domicile){
    return userService.updateHouse(domicile);
  }

  //Modification des paramètres

  toggleAudioNotification(audioParam){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("audioParam", audioParam,'string');
    print(audioParam);
  }

  toggleConnectMode(connectMode){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("connectMode", connectMode,'string');
  }

  Future<String> getAudioNotification() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    var test = await SharedPreferenceHelper(instance).getData("audioParam");
    print(test);
    return test;
  }

  Future<String> getConnectMode() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    return SharedPreferenceHelper(instance).getData("connectMode",'bool');
  }
}

final UserProvider userProvider = UserProvider();