import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/web_dashboard/dashboard_body/top_bar/top_bar.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';
import 'package:storia/web_dashboard/dashboard_body/side_bar/side_bar.dart';

class Dashboard extends ConsumerStatefulWidget {
  final Widget child;
  const Dashboard({super.key, required this.child});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final snackBarContent = ref.watch(snackBarProvider);

    //Mostrar aviso
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (snackBarContent != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: snackBarContent.message.length * 10,
                  decoration: BoxDecoration(
                    color:
                        snackBarContent.error
                            ? const Color.fromARGB(255, 153, 15, 5)
                            : DashboardTheme.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          snackBarContent.error
                              ? const Color.fromARGB(255, 178, 42, 33)
                              : const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      snackBarContent.message,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: DashboardTheme.background,
      drawer:
          !isDesktop
              ? Drawer(
                backgroundColor: DashboardTheme.background,
                child: SideBar(),
              )
              : null,
      body: Row(
        children: [
          if (isDesktop) SideBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 4),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: DashboardTheme.primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                  border: Border.all(color: Color.fromARGB(255, 24, 24, 24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(130, 5, 5, 5),
                      offset: Offset.zero,
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 22, right: 20, left: 20),
                  child: Column(
                    children: [
                      TopBar(),
                      SizedBox(height: 16),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 33, 33, 33),
                      ),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 700),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
