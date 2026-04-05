import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/providers/auth_state_provider.dart';
import 'package:storia/providers/router_refresh_provider.dart';
import 'package:storia/web_dashboard/auth_gate.dart';
import 'package:storia/web_dashboard/dashboard_body/dashboard.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/admin/admin_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/billing/billing_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/chapter_create_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapters_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/status_model.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/home/home_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/banners_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/layout_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/lists/lists_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/user/user_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/work_creation_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/works_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: ref.watch(routerRefreshNotifierProvider),

    redirect: (context, state) {
      final user = ref.read(authStateProvider);
      final userDoc = ref.read(userDocumentProvider);

      final location = state.matchedLocation;
      final isAuthRoute = location == '/auth';

      // Firebase ainda não respondeu
      if (user.isLoading) {
        return null;
      }

      if (user.value == null) {
        return isAuthRoute ? null : '/auth';
      }

      if (userDoc.isLoading) {
        return null;
      }

      if (userDoc.value == null) {
        return isAuthRoute ? null : '/auth';
      }

      // 🔹 Autenticado
      if (isAuthRoute) {
        return isAuthRoute ? '/dashboard/inicio' : null;
      }

      return null;
    },

    initialLocation: '/auth',

    ///Rotas
    routes: [
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) => NoTransitionPage(child: AuthGate()),
      ),

      GoRoute(
        path: '/',
        pageBuilder: (context, state) => NoTransitionPage(child: AuthGate()),
      ),

      //Shell do Dashboard
      ShellRoute(
        builder: (context, state, child) => Dashboard(child: child),
        routes: [
          GoRoute(
            path: '/dashboard/inicio',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/dashboard/faturamento',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: BillingPage()),
          ),
          GoRoute(
            path: '/dashboard/perfil',
            pageBuilder:
                (context, state) => NoTransitionPage(child: UserPage()),
          ),
          GoRoute(
            path: '/dashboard/obras',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: WorksPage()),
          ),

          GoRoute(
            path: '/dashboard/obras/criar',
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: WorkCreationPage()),
          ),

          GoRoute(
            path: '/dashboard/obras/:id/editar',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage(child: WorkCreationPage(contentId: id));
            },
          ),

          //Capítulos
          GoRoute(
            path: '/dashboard/capitulos/:tipo',
            pageBuilder: (context, state) {
              final tipo = state.pathParameters['tipo'];

              Widget child;
              switch (tipo) {
                case 'publicados':
                  child = Publicados();
                  break;
                case 'agendados':
                  child = Agendados();
                  break;
                case 'rascunhos':
                  child = Rascunhos();
                  break;
                default:
                  child = Publicados();
              }

              return NoTransitionPage(child: ChaptersPage(child: child));
            },
          ),
          GoRoute(
            path: '/dashboard/capitulos/:id/criar',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'];
              return NoTransitionPage(child: ChapterCreatePage(contentId: id!));
            },
          ),
          GoRoute(
            path: '/dashboard/capitulos/:contentId/:id/editar',
            pageBuilder: (context, state) {
              final contentId = state.pathParameters['contentId'];
              final id = state.pathParameters['id'];
              return NoTransitionPage(
                child: ChapterCreatePage(chapterId: id, contentId: contentId!),
              );
            },
          ),

          GoRoute(
            path: '/dashboard/layout/:section',
            pageBuilder: (context, state) {
              final section = state.pathParameters['section'];

              Widget child;
              switch (section) {
                case 'banners':
                  child = BannersPage();
                  break;

                case 'lists':
                  child = ListsPage();
                  break;

                default:
                  child = BannersPage();
              }
              return NoTransitionPage(child: LayoutPage(child: child));
            },
          ),

          GoRoute(
            path: '/dashboard/admin',
            pageBuilder:
                (context, state) => NoTransitionPage(child: AdminPage()),
          ),
        ],
      ),
    ],
  );
});
