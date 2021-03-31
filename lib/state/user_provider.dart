import 'package:dartz/dartz.dart';
import 'package:near_me/models/user.dart';
import 'package:near_me/networking/services/user_service.dart';
import 'package:near_me/utils/n_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_provider.dart';
import 'dart:io' show Platform;

class UserProvider extends BaseProvider {
  Either<NException,User> userData = Right(User());

  //stockage du domicile
  storeDomicile(domicile) {
    this.toggleLoadingState();
    userService.updateHouse().then((data) {
      userData = Right(data);
      this.toggleLoadingState();
    }).catchError((error) {
      userData = Left(error);
      this.toggleLoadingState();
    });
  }


}

final UserProvider userProvider = UserProvider();
