
import 'package:dartz/dartz.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/networking/services/alert_service.dart';
import 'package:mapane/utils/n_exception.dart';
import 'base_provider.dart';

class AlertProvider extends BaseProvider{

  Either<NException,List<Alert>> alertList = Right([]);

  getAlertList(){
    this.toggleLoadingState();
    alertService.getAlerts().then((alerts){
      alertList = Right(alerts);
    }).catchError((error){
      alertList = Left(error);
      this.toggleLoadingState();
    });
  }

  getAlertByUser(id){
    this.toggleLoadingState();
    alertService.getAlertByUser(id).then((alerts){
      alertList = Right(alerts);
    }).catchError((error){
      alertList = Left(error);
      this.toggleLoadingState();
    });
  }

}