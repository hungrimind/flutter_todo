import 'dart:async';

class FakeDataSource {
  Future<void> add() async {
    // In a real app, this would be a call to a local database or a remote API
  }

  Future<void> remove() async {
    // In a real app, this would be a call to a local database or a remote API
  }

  Future<void> update() async {
    // In a real app, this would be a call to a local database or a remote API
  }
}

// A simple implementation of a reactive stream. Provides both a stream and a value.
class BehaviorSubject<T> {
  // StreamController with broadcast mode
  final StreamController<T> _controller;
  T _currentValue;

  // Constructor to initialize with an initial value
  BehaviorSubject(T initialValue)
      : _currentValue = initialValue,
        _controller = StreamController<T>.broadcast();

  // Getter for the current value
  T get value => _currentValue;

  // Adds a new value and broadcasts it to all listeners
  void add(T newValue) {
    _currentValue = newValue;
    _controller.add(newValue);
  }

  // Exposes the stream to listen to changes
  Stream<T> get stream => _controller.stream;

  // Subscribes a listener and immediately emits the current value
  StreamSubscription<T> listen(void Function(T) onData) {
    final subscription = _controller.stream.listen(onData);
    // Emit the current value immediately
    onData(_currentValue);
    return subscription;
  }

  // Closes the StreamController when done
  Future<void> close() async {
    await _controller.close();
  }
}
