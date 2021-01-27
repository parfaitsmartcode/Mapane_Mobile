import 'package:dartz/dartz.dart';
import 'package:mapane/models/user.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mapane/utils/shared_preference_helper.dart';
import 'base_provider.dart';



class UserProvider extends BaseProvider{
  // Either<NException,List<User>> alertList = Right([]);

  bool audioVal = false;
  bool connectVal = false;

  UserProvider(){
      // print("++++++++++++++++++++++ok+++++++++++++++++");
      // this.getAudioNotification().then((value) {
      //   print("valeur des preferences " + value.toString());
      // } );
      // this.getAudioNotification().then((value) => this.audioVal = value );
      // this.getConnectMode().then((value) => this.connectVal = value );
      // print("valeur du booléean " + audioVal.toString());
  }

  modifyAudioParam(bool audioVal){
    this.audioVal = audioVal ? false : true;
    storeAudioNotification(audioVal);
    notifyListeners();
  }

  modifyConnectParam(bool connectVal){
    this.connectVal = connectVal ? false : true;
    storeConnectMode(connectVal);
    notifyListeners();
  }

  setAudioNotification(){
    this.getAudioNotification().then((value) => this.audioVal = value );
    notifyListeners();
  }

  setConnectMode(){
    this.getConnectMode().then((value) => this.connectVal = value );
    notifyListeners();
  }

  //stockage du domicile
  storeDomicile(domicile){
    return userService.updateHouse(0,0,domicile);
  }

  //Modification des paramètres dans le SharedPreferences

  storeAudioNotification(audioParam){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("audioParam", audioParam, "bool");
  }

  storeConnectMode(connectMode){
    Future<SharedPreferences> instance = SharedPreferences.getInstance();
    SharedPreferenceHelper(instance)
        .storeData("connectMode", connectMode,"bool");
  }

  Future<bool>getAudioNotification() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    var value = await SharedPreferenceHelper(instance).getData("audioParam","bool");
    print("type de value " + value.runtimeType.toString());
    if(value == null){
      return false;
    }else{
      print(value);
      return value;
    }
  }

  Future<bool>getConnectMode() async {
    Future<SharedPreferences>  instance = SharedPreferences.getInstance();
    var value = await SharedPreferenceHelper(instance).getData("connectMode","bool");
    if(value == null){
      return false;
    }else{
      print(value);
      return value;
    }
  }
}

final UserProvider userProvider = UserProvider();