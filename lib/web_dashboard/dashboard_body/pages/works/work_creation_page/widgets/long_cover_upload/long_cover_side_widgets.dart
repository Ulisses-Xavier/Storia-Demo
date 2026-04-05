import 'package:flutter/material.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class LongCoverSideWidgets extends StatelessWidget {
  final VoidCallback useMainCoverToggle;
  final bool useMainCover;
  final Map<String, TextEditingController> rgbControllers;
  final bool useLongImageFromContentToEdit;
  final VoidCallback useLongImageFromContentToEditToggle;
  final ContentModel? contentToEdit;
  const LongCoverSideWidgets({
    super.key,
    required this.useMainCoverToggle,
    required this.useMainCover,
    required this.rgbControllers,
    required this.useLongImageFromContentToEdit,
    required this.useLongImageFromContentToEditToggle,
    this.contentToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color.fromARGB(255, 42, 42, 42)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (contentToEdit != null)
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 56, 92, 182),
                            border: Border.all(
                              color: Color.fromARGB(40, 127, 163, 255),
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap:
                                      () =>
                                          useLongImageFromContentToEditToggle(),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          146,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                    child:
                                        useLongImageFromContentToEdit
                                            ? Center(
                                              child: AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds: 250,
                                                ),
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Usar capa de listagem salva',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (contentToEdit == null ||
                      (contentToEdit != null && !useLongImageFromContentToEdit))
                    SizedBox(height: 10),
                  if (contentToEdit == null ||
                      (contentToEdit != null && !useLongImageFromContentToEdit))
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 56, 92, 182),
                            border: Border.all(
                              color: Color.fromARGB(40, 127, 163, 255),
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => useMainCoverToggle(),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          146,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                    child:
                                        useMainCover
                                            ? Center(
                                              child: AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds: 250,
                                                ),
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Usar capa original',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: DashboardTheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromARGB(255, 42, 42, 42),
                          ),
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
                              color: Color.fromARGB(255, 000, 000, 000),
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
                          border: Border.all(
                            color: Color.fromARGB(255, 42, 42, 42),
                          ),
                          borderRadius: 10,
                          controller: rgbControllers['r'],
                          isNumber: true,
                          tipText: 'R',
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
                          border: Border.all(
                            color: Color.fromARGB(255, 42, 42, 42),
                          ),
                          controller: rgbControllers['g'],
                          borderRadius: 10,
                          isNumber: true,
                          tipText: 'G',
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
                          border: Border.all(
                            color: Color.fromARGB(255, 42, 42, 42),
                          ),
                          borderRadius: 10,
                          controller: rgbControllers['b'],
                          tipText: 'B',
                          isNumber: true,
                          distanceBetween: 0,
                          maxLines: 1,
                          cursorColor: DashboardTheme.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 7),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(40, 56, 92, 182),
              border: Border.all(color: Color.fromARGB(40, 127, 163, 255)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
