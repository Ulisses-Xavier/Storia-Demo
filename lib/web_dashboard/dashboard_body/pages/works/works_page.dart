import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/my_error_widget.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/no_works.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/works_list.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/user_contents_provider.dart';

class WorksPage extends ConsumerWidget {
  const WorksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userContents = ref.watch(userContentsProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
        child: Column(
          children: [
            //Botão de Criar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  isSelected: false,
                  text: 'Criar Nova',
                  color: DashboardTheme.blue,
                  height: 40,
                  width: 130,
                  textColor: Colors.white,
                  borderRadius: 10,
                  rightIcon: LucideIcons.plus,
                  spaceBetween: 2,
                  onHover: const Color.fromARGB(255, 42, 70, 142),
                  alignment: MainAxisAlignment.center,
                  iconSize: 15,
                  fontSize: 15,
                  onTap: () => context.go('/dashboard/obras/criar'),
                ),
              ],
            ),

            SizedBox(height: 10),

            //Obras List
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: DashboardTheme.secondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(30, 5, 5, 5),
                    blurRadius: 5,
                    spreadRadius: 5,
                    offset: Offset.fromDirection(1, 2),
                  ),
                ],
              ),
              child: userContents.when(
                data: (contents) {
                  if (contents.isEmpty) {
                    return const Center(child: NoWorks());
                  }
                  return WorksList(contentList: contents);
                },
                error: (_, __) {
                  return MyErrorWidget();
                },
                loading: () {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 90),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: DashboardTheme.blue,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
