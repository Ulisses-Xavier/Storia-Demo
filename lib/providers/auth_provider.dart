import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/providers/auth_state_provider.dart';

enum AuthStatus { loading, unauthenticated, authenticated, needsUserCheck }

final authStatusProvider = Provider<AuthStatus>((ref) {
  final auth = ref.watch(authStateProvider);

  if (auth.isLoading) return AuthStatus.loading;
  if (auth.hasError) return AuthStatus.unauthenticated;

  final user = auth.value;
  if (user == null) return AuthStatus.unauthenticated;

  return AuthStatus.authenticated;
});
