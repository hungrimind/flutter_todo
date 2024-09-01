import 'package:flutter/foundation.dart';

class ViewModel extends ChangeNotifier {
  /// Tracks whether the ViewModel has been disposed, preventing further calls to [notifyListeners].
  bool disposed = false;

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
