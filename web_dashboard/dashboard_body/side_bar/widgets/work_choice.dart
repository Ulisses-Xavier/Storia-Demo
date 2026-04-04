import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/my_error_widget.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/no_works.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/user_contents_provider.dart';

class WorkChoice extends ConsumerStatefulWidget {
  const WorkChoice({super.key});

  @override
  ConsumerState<WorkChoice> createState() => _WorkChoiceState();
}

class _WorkChoiceState extends ConsumerState<WorkChoice> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic> hover = {};

  @override
  Widget build(BuildContext context) {
    final userContents = ref.watch(userContentsProvider);
    return Center(
      child: Container(
        height: 330,
        width: 400,
        decoration: BoxDecoration(
          color: DashboardTheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Escolha uma obra:',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  MyButton(
                    isSelected: false,
                    color: Colors.transparent,
                    onHover: Colors.transparent,
                    icon: LucideIcons.x,
                    alignment: MainAxisAlignment.center,
                    spaceBetween: 0,
                    iconColor: Colors.white,
                    iconSize: 15,
                    splashColor: Colors.transparent,
                    height: 30,
                    width: 35,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              userContents.when(
                data: (contents) {
                  if (contents.isEmpty) {
                    return Center(child: NoWorks());
                  }

                  final data = contents;

                  return SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final double padding = index == 0 ? 5 : 0;
                        return Padding(
                          padding: EdgeInsets.only(left: padding, top: 5),
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                hover = {'index': index};
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                hover = {};
                              });
                            },
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(data[index]);
                              },
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          if (hover['index'] == index)
                                            Container(
                                              height: 220,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      10,
                                                    ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: DashboardTheme.blue,
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10,
                                                ),
                                            child: Image.network(
                                              data[index].cover!,
                                              height: 220,
                                              width: 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        width: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data[index].title!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  hover['index'] == index
                                                      ? DashboardTheme.blue
                                                      : Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: DashboardTheme.blue,
                      ),
                    ),
                  );
                },
                error: (_, _) {
                  return MyErrorWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
