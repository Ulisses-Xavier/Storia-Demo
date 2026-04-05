import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/mobile/app/pages/main/main_page.dart';
import 'package:storia/mobile/app/pages/home/home.dart';
import 'package:storia/mobile/app/pages/library/library_page.dart';
import 'package:storia/mobile/app/pages/more/more_page.dart';
import 'package:storia/mobile/app/pages/search/search_page.dart';
import 'package:storia/mobile/app/sub_pages/chapter_page.dart/chapter_page.dart';
import 'package:storia/mobile/app/sub_pages/content_list_page.dart/local_content_list_page.dart';
import 'package:storia/mobile/app/sub_pages/content_page/content_page.dart';

final goRouter = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainPage(page: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomePage()),
          ),

          GoRoute(
            path: '/search',
            pageBuilder:
                (context, state) => NoTransitionPage(child: SearchPage()),
          ),
          GoRoute(
            path: '/library',
            pageBuilder:
                (context, state) => NoTransitionPage(child: LibraryPage()),
          ),
          GoRoute(
            path: '/more',
            pageBuilder:
                (context, state) => NoTransitionPage(child: MorePage()),
          ),
        ],
      ),

      GoRoute(
        path: '/content/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            child: ContentPage(id: id),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0); // direita → esquerda
              const end = Offset.zero;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: Curves.ease));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: 'chapter/:number',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              final number = state.pathParameters['number']!;

              return NoTransitionPage(
                child: ChapterPage(
                  contentId: id,
                  chapterNumber: int.parse(number),
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/local-content-list/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;

          return CustomTransitionPage(
            child: LocalContentListPage(id: id),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0); // direita → esquerda
              const end = Offset.zero;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: Curves.ease));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
});
