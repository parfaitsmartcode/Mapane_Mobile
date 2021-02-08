import 'package:flutter/foundation.dart';
import 'package:mapane/state/LoadingState.dart';


abstract class BaseProvider extends ChangeNotifier {
  LoadingState loadingState = LoadingState.waiting;

  toggleLoadingState() {
    loadingState = (loadingState == LoadingState.loading) ? LoadingState.waiting : LoadingState.loading;
    notifyListeners();
  }
}
