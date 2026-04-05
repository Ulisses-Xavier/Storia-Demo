import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class SaveCover extends StatefulWidget {
  final Uint8List image;
  const SaveCover({super.key, required this.image});

  @override
  State<SaveCover> createState() => _SaveCoverState();
}

class _SaveCoverState extends State<SaveCover> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: DashboardTheme.primary,
                border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Salvar para usar depois?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        MyButton(
                          alignment: MainAxisAlignment.center,
                          isSelected: false,
                          height: 40,
                          loadingColor: Colors.white,
                          loadingSize: 0.5,
                          isLoading: isLoading,
                          width: 120,
                          color: DashboardTheme.blue,
                          splashColor: const Color.fromARGB(57, 255, 255, 255),
                          onHover: DashboardTheme.blue,

                          spaceBetween: 0,
                          fontSize: 15,
                          borderRadius: 10,
                          textColor: Colors.white,
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });

                            final function = FirebaseFunctions.instance
                                .httpsCallable('processAndUploadImage');

                            await function.call({
                              'imageBase64': base64Encode(widget.image),
                              'isComicPage': false,
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(width: 6),
                        MyButton(
                          alignment: MainAxisAlignment.center,
                          isSelected: false,
                          height: 40,
                          loadingColor: Colors.white,
                          width: 160,
                          color: const Color.fromARGB(125, 42, 42, 42),
                          splashColor: const Color.fromARGB(57, 255, 255, 255),
                          onHover: const Color.fromARGB(170, 42, 42, 42),
                          text: 'Não salvar',
                          fontSize: 15,
                          borderRadius: 10,
                          textColor: Colors.white,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
