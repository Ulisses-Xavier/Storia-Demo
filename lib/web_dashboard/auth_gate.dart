import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/providers/auth_state_provider.dart';
import 'package:storia/web_dashboard/login/login_page.dart';
import 'package:storia/web_dashboard/login/widgets/sections/loading.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStateProvider);
    final userDoc = ref.watch(userDocumentProvider);

    if (authStatus.isLoading) {
      return LoginLoading();
    }

    if (authStatus.value == null) {
      return LoginPage();
    }

    if (userDoc.isLoading) {
      return LoginLoading();
    }

    if (userDoc.value == null) {
      return LoginPage();
    }

    // estado final: pode navegar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      context.go('/dashboard/inicio');
    });

    return const SizedBox.shrink();
  }
}
