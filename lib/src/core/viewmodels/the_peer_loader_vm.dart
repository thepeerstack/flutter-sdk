import 'package:flutter/material.dart';

class ThePeerLoaderVM extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// Run Task and show loading
  void simulate(
    Function() callback, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    /// Start Loading
    isLoading = true;

    /// Run delayed Task
    await Future.delayed(duration);

    /// End Loading
    isLoading = false;

    callback.call();
  }

  /// Run Task and show loading
  void runTask<T>(Future Function()? task) async {
    /// Load
    isLoading = true;

    /// Run async Task
    if (task != null) await task.call();

    /// Stop Loading
    isLoading = false;
  }
}
