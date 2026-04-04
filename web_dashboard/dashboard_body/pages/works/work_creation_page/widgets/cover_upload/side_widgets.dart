import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class SideWidgets extends StatefulWidget {
  final Uint8List? image;
  final bool useImageFromContentToEdit;
  final VoidCallback useImageFromContentToEditToggle;
  final ContentModel? contentToEdit;
  const SideWidgets({
    super.key,
    required this.image,
    required this.useImageFromContentToEdit,
    required this.useImageFromContentToEditToggle,
    this.contentToEdit,
  });

  @override
  State<SideWidgets> createState() => _SideWidgetsState();
}

class _SideWidgetsState extends State<SideWidgets> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 268,
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color.fromARGB(255, 42, 42, 42)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  if (widget.contentToEdit != null)
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
                                  onTap:
                                      () =>
                                          widget
                                              .useImageFromContentToEditToggle(),
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
                                        widget.useImageFromContentToEdit
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
                                  'Usar Imagem Salva',
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
