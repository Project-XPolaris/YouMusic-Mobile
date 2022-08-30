import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  var activeTab = 0;
  setActiveTab(int index){
    activeTab = index;
    notifyListeners();
  }
}