import 'package:flutter/foundation.dart';

enum ViewState { initial, loading, loaded, error }

abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.initial;
  String? _errorMessage;
  bool _disposed = false;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;

  @protected
  void setState(ViewState newState, {String? errorMessage}) {
    _state = newState;
    _errorMessage = errorMessage;
    safeNotifyListeners();
  }

  @protected
  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
