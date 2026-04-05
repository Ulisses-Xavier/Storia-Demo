import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnackBarContent {
  final String message;
  final bool error;
  SnackBarContent({required this.message, required this.error});
}

class SnackBarNotifier extends Notifier<SnackBarContent?> {
  @override
  SnackBarContent? build() {
    return null;
  }

  void showMessage(SnackBarContent snackBar) {
    state = snackBar;
    Future.delayed(Duration(seconds: 5), () => state = null);
  }
}

final snackBarProvider = NotifierProvider<SnackBarNotifier, SnackBarContent?>(
  () => SnackBarNotifier(),
);
