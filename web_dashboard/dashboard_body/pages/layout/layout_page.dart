import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/banners_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/lists/lists_page.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/widgets/layout_top_bar.dart';

class LayoutPage extends ConsumerStatefulWidget {
  final Widget child;
  const LayoutPage({super.key, required this.child});

  @override
  ConsumerState<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends ConsumerState<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    final path = GoRouter.of(context).state.uri.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutTopBar(),
          SizedBox(height: 10),
          path.contains('layout/banners') ? BannersPage() : ListsPage(),
        ],
      ),
    );
  }
}
