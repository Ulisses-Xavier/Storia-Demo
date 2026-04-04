import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:storia/providers/auth_provider.dart';
import 'package:storia/providers/user_check_provider.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

final routerRefreshNotifierProvider =
    ChangeNotifierProvider<RouterRefreshNotifier>((ref) {
      final notifier = RouterRefreshNotifier();

      ref.listen<AuthStatus>(authStatusProvider, (_, __) {
        notifier.refresh();
      });

      ref.listen<UserCheckStatus>(userCheckProvider, (_, __) {
        notifier.refresh();
      });

      return notifier;
    });
