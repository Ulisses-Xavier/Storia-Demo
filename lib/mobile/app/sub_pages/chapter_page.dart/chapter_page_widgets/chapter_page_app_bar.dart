import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/sub_pages/chapter_page.dart/chapter_page_widgets/preferences_bottom_sheet.dart';
import 'package:storia/utilities/utilities.dart';

class ChapterPageAppBar extends StatelessWidget {
  final bool showUi;
  final String title;
  final int order;
  final Future<void> Function({
    bool? isDarkModeNew,
    double? fontSizeNew,
    String? fontFamilyNew,
  })
  setPrefs;
  const ChapterPageAppBar({
    super.key,
    required this.showUi,
    required this.title,
    required this.order,
    required this.setPrefs,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.topCenter,
      child: AnimatedOpacity(
        opacity: showUi ? 1 : 0,
        duration: const Duration(milliseconds: 2000),
        child: AnimatedSlide(
          offset: showUi ? Offset(0, 0) : Offset(0, -1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          //
          //
          //
          //CONTAINER\\
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.only(top: 36, right: 20, left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(
                          PhosphorIcons.arrowLeft(),
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Capítulo $order',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 197, 197, 197),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(
                            width: 260,
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  MyButton(
                    height: 40,
                    width: 40,
                    isSelected: false,
                    borderRadius: 100,
                    color: Colors.transparent,
                    icon: PhosphorIcons.slidersHorizontal(),
                    spaceBetween: 0,
                    alignment: MainAxisAlignment.center,
                    iconColor: Colors.white,
                    iconSize: 23,
                    splashColor: const Color.fromARGB(86, 255, 255, 255),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder:
                            (context) =>
                                PreferencesBottomSheet(setPrefs: setPrefs),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
