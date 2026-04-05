import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/web_dashboard/router.dart';

// Provider que retorna o path atual e reage às mudanças
final pathProvider = StateNotifierProvider<PathNotifier, String>((ref) {
  final router = ref.read(goRouterProvider);
  return PathNotifier(router);
});

class PathNotifier extends StateNotifier<String> {
  final GoRouter _router;

  PathNotifier(this._router)
    : super(_router.routeInformationProvider.value.uri.toString()) {
    // Escuta alterações do routeInformationProvider
    _router.routeInformationProvider.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    // Atualiza o state sempre que a rota mudar
    state = _router.routeInformationProvider.value.uri.toString();
  }

  @override
  void dispose() {
    // Remove listener ao desmontar
    _router.routeInformationProvider.removeListener(_onRouteChanged);
    super.dispose();
  }
}
