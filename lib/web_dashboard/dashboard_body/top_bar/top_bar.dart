import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/providers/auth_state_provider.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/top_bar/widgets/page_title.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class TopBar extends ConsumerStatefulWidget {
  const TopBar({super.key});

  @override
  ConsumerState<TopBar> createState() => _TopBarState();
}

class _TopBarState extends ConsumerState<TopBar> {
  @override
  Widget build(BuildContext context) {
    String path = GoRouter.of(context).state.uri.toString();
    final screenWidth = MediaQuery.of(context).size.width;
    final user = ref.watch(userDocumentProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            PageTitle(path: path),
            if (screenWidth < 1024)
              Row(
                children: [
                  SizedBox(width: 10),
                  MyButton(
                    isSelected: false,
                    height: 40,
                    width: 40,
                    color: DashboardTheme.secondary,
                    borderRadius: 10,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    icon: LucideIcons.arrowRight,
                    spaceBetween: 0,
                    alignment: MainAxisAlignment.center,
                    onTap: () => Scaffold.of(context).openDrawer(),
                  ),
                ],
              ),
          ],
        ),

        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.value != null ? user.value!.name! : 'Sem nome',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user.value != null ? user.value!.email! : 'Sem email',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 7,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),

            SizedBox(width: 10),

            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child:
                    user.value != null && user.value!.image != null
                        ? ClipOval(
                          child: Image.network(
                            user.value!.image!,
                            fit: BoxFit.cover,
                            height: 38,
                            width: 38,
                          ),
                        )
                        : Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: DashboardTheme.blue,
                          ),
                          child: Icon(
                            LucideIcons.user300,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
