import 'package:flutter/material.dart';
import 'package:storia/mobile/app/sub_pages/popups/login_bottom_sheet/login_layout.dart';
import 'package:storia/mobile/app/sub_pages/popups/login_bottom_sheet/register_layout.dart';

class LoginBottomSheet extends StatefulWidget {
  final Color color;
  final BuildContext rootContext;
  const LoginBottomSheet({
    super.key,
    required this.color,
    required this.rootContext,
  });

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Container(
          height: 700,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 2,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(149, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 10),
                PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color.fromARGB(110, 255, 255, 255),
                    indicatorWeight: 2,
                    tabs: [Tab(text: 'Login'), Tab(text: 'Registrar')],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Builder(
                        builder:
                            (context) => LoginLayout(
                              controller: _tabController,
                              rootContext: widget.rootContext,
                            ),
                      ),
                      Builder(
                        builder:
                            (context) => RegisterLayout(
                              controller: _tabController,
                              rootContext: widget.rootContext,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
