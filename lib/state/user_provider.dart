import 'package:dartz/dartz.dart';
import 'package:mapane/models/user.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapane/utils/shared_preference_helper.dart';
import 'base_provider.dart';



class UserProvider extends BaseProvider{
  // Either<NException,List<User>> alertList = Right([]);

  bool audioVal;
  bool connectVal;

  UserProvider(){
      this.audioVal = this.getAudioNotification();
      this.connectVal = this.getConnectMode();
  }

  modifyAudioParam(bool audioVal){
    this.audioVal = audioVal ? false : true;
    notifyListeners();
  }

  modifyConnectParam(bool connectVal){
    this.connectVal = connectVal ? false : true;
    notifyListeners();
  }

  //stockage du domicile
  storeDomicile(domicile){
    return userService.updateHouse(domicile);
  }

  //Modification des paramètres dans le SharedPreferences

  toggleAudioNotification(audioParam){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("audioParam", audioParam, "bool");
    this.audioVal = audioParam;
  }

  toggleConnectMode(connectMode){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("connectMode", connectMode, "bool");
  }

  getAudioNotification() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    return await SharedPreferenceHelper(instance).getData("audioParam","bool");
  }

  getConnectMode() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    return await SharedPreferenceHelper(instance).getData("connectMode","bool");
  }
}

final UserProvider userProvider = UserProvider();