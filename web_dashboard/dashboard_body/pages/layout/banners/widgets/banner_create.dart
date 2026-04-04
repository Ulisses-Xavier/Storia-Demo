import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/widgets/select_route_popup.dart';

import 'package:storia/web_dashboard/dashboard_theme.dart';

class BannerCreate extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController aController;
  final TextEditingController rController;
  final TextEditingController gController;
  final TextEditingController bController;
  final TextEditingController tagController;
  final TextEditingController aTagController;
  final TextEditingController rTagController;
  final TextEditingController gTagController;
  final TextEditingController bTagController;
  final TextEditingController routerController;
  final int? aTag;
  final int? rTag;
  final int? gTag;
  final int? bTag;
  final String? tagTitle;
  final VoidCallback setTag;
  final ValueChanged<String> removeTag;
  final List<Map<String, dynamic>> tags;
  const BannerCreate({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.aController,
    required this.removeTag,
    required this.tags,
    required this.rController,
    required this.gController,
    required this.routerController,
    required this.bController,
    required this.tagController,
    required this.aTagController,
    required this.setTag,
    required this.rTagController,
    required this.gTagController,
    required this.bTagController,
    required this.aTag,
    required this.rTag,
    required this.gTag,
    required this.bTag,
    required this.tagTitle,
  });

  @override
  State<BannerCreate> createState() => _BannerCreateState();
}

class _BannerCreateState extends State<BannerCreate> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              backgroundColor: DashboardTheme.secondary,
              border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              borderRadius: 10,
              tipText: 'Título...',
              controller: widget.titleController,
              distanceBetween: 0,
              cursorColor: DashboardTheme.blue,
            ),
            SizedBox(height: 8),
            MyTextField(
              backgroundColor: DashboardTheme.secondary,
              border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              borderRadius: 10,
              tipText: 'Descrição...',
              controller: widget.descriptionController,
              distanceBetween: 0,
              cursorColor: DashboardTheme.blue,
              height: 100,
              expands: true,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    isNumber: true,
                    tipText: 'A',
                    controller: widget.aController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    isNumber: true,
                    tipText: 'R',
                    controller: widget.rController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    isNumber: true,
                    tipText: 'G',
                    controller: widget.gController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    tipText: 'B',
                    isNumber: true,
                    controller: widget.bController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            MyTextField(
              backgroundColor: DashboardTheme.secondary,
              border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              borderRadius: 10,
              tipText: 'Route...',
              controller: widget.routerController,
              distanceBetween: 0,
              maxLines: 1,
              cursorColor: DashboardTheme.blue,
              rightButton: MyButton(
                isSelected: false,
                height: 35,
                width: 35,
                color: const Color.fromARGB(5, 255, 255, 255),
                onHover: const Color.fromARGB(10, 255, 255, 255),
                splashColor: const Color.fromARGB(15, 255, 255, 255),
                borderRadius: 10,
                icon: PhosphorIcons.clipboardText(),
                iconColor: Colors.white,
                iconSize: 15,
                spaceBetween: 0,
                alignment: MainAxisAlignment.center,
                onTap: () async {
                  final String? result = await showDialog(
                    context: context,
                    builder: (context) => SelectRoutePopup(),
                  );

                  if (result == null) return;

                  setState(() {
                    widget.routerController.text = result;
                  });
                },
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    tipText: 'Nova tag...',
                    controller: widget.tagController,
                    distanceBetween: 0,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
                SizedBox(width: 8),
                MyButton(
                  alignment: MainAxisAlignment.center,
                  isSelected: false,
                  height: 42,
                  loadingColor: Colors.white,
                  loadingSize: 0.5,
                  width: 50,
                  color: DashboardTheme.blue,
                  splashColor: const Color.fromARGB(57, 255, 255, 255),
                  onHover: DashboardTheme.blue,
                  rightIcon: LucideIcons.plus,
                  iconSize: 13,
                  spaceBetween: 0,
                  borderRadius: 7,
                  onTap: () {
                    if (widget.tagTitle != null &&
                        widget.tagTitle!.isNotEmpty) {
                      widget.setTag();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            //Tag Color
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
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
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          widget.aTag ?? 255,
                          widget.rTag ?? 000,
                          widget.gTag ?? 000,
                          widget.bTag ?? 000,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(30, 5, 5, 5),
                            blurRadius: 5,
                            spreadRadius: 5,
                            offset: Offset.fromDirection(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    isNumber: true,
                    tipText: 'R',
                    controller: widget.rTagController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    isNumber: true,
                    tipText: 'G',
                    controller: widget.gTagController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    backgroundColor: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    borderRadius: 10,
                    tipText: 'B',
                    isNumber: true,
                    controller: widget.bTagController,
                    distanceBetween: 0,
                    maxLines: 1,
                    cursorColor: DashboardTheme.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  children:
                      widget.tags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                255,
                                tag['r'],
                                tag['g'],
                                tag['b'],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    tag['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      widget.removeTag(tag['title']);
                                    },
                                    child: Icon(
                                      PhosphorIcons.x(),
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
