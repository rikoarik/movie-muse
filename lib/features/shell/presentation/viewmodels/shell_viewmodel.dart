import 'package:flutter/foundation.dart';

class ShellViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int _searchFocusTrigger = 0;

  int get currentIndex => _currentIndex;
  int get searchFocusTrigger => _searchFocusTrigger;

  void selectTab(int index) {
    if (index < 0 || index > 2 || index == _currentIndex) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }

  void openSearchAndFocus() {
    _currentIndex = 1;
    _searchFocusTrigger++;
    notifyListeners();
  }
}
