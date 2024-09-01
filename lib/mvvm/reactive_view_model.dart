import 'package:flutter/foundation.dart';
import 'package:todo/mvvm/view_model.dart';

abstract class ReactiveViewModel extends ViewModel {
  /// Initializes the ReactiveViewModel and sets up listeners for the provided services.
  ReactiveViewModel() {
    _reactToServices(services);
  }

  late List<Listenable> _services;

  /// A list of services that the ViewModel listens to for changes.
  List<Listenable> get services;

  @override
  void dispose() {
    // Remove listeners from each service to prevent memory leaks.
    for (final service in _services) {
      service.removeListener(_indicateChange);
    }
    super.dispose();
  }

  /// Attaches listeners to the provided services.
  void _reactToServices(List<Listenable> services) {
    _services = services;
    for (final service in _services) {
      service.addListener(_indicateChange);
    }
  }

  /// Notifies listeners when any of the services change.
  void _indicateChange() {
    notifyListeners();
  }
}
