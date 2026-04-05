import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/providers/user_check_provider.dart';
import 'package:storia/providers/register_data_provider.dart';

class LoginLoading extends ConsumerStatefulWidget {
  const LoginLoading({super.key});

  @override
  ConsumerState<LoginLoading> createState() => _LoginLoadingState();
}

class _LoginLoadingState extends ConsumerState<LoginLoading> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = FirebaseAuth.instance.currentUser;
      final data = ref.read(registerDataNotifier);

      if (user != null) {
        ref.read(userCheckProvider.notifier).check(user, data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardTheme.background,
      body: Center(
        child: CircularProgressIndicator(color: DashboardTheme.blue),
      ),
    );
  }
}
