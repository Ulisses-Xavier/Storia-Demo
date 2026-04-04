import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/sub_pages/chapter_page.dart/chapter_page_widgets/preferences_riverpod.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/utilities/utilities.dart';

class PreferencesBottomSheet extends ConsumerStatefulWidget {
  final Future<void> Function({
    bool? isDarkModeNew,
    double? fontSizeNew,
    String? fontFamilyNew,
  })
  setPrefs;
  const PreferencesBottomSheet({super.key, required this.setPrefs});

  @override
  ConsumerState<PreferencesBottomSheet> createState() =>
      _PreferencesBottomSheetState();
}

class _PreferencesBottomSheetState
    extends ConsumerState<PreferencesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    PreferencesState data = ref.watch(preferencesNotifier);
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: data.isDarkMode ? ColorTheme.secondary : Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 20,
        ),
        child: Column(
          children: [
            Container(
              height: 2,
              width: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(149, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap:
                      () async => await widget.setPrefs(
                        isDarkModeNew: !data.isDarkMode,
                      ),
                  child: Container(
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                      color:
                          data.isDarkMode ? Colors.black : ColorTheme.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          MyButton(
                            isSelected: false,
                            height: 40,
                            width: 40,
                            borderRadius: 100,
                            color: ColorTheme.blue,
                            icon:
                                data.isDarkMode
                                    ? PhosphorIcons.moon()
                                    : PhosphorIcons.sun(),
                            spaceBetween: 0,
                            alignment: MainAxisAlignment.center,
                            iconColor: Colors.white,
                            iconSize: 23,
                            splashColor: const Color.fromARGB(
                              86,
                              255,
                              255,
                              255,
                            ),
                            onTap: () async {
                              await widget.setPrefs(
                                isDarkModeNew: !data.isDarkMode,
                              );
                            },
                          ),
                          SizedBox(width: 6),
                          Text(
                            data.isDarkMode ? 'Modo escuro' : 'Modo claro',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //
                //
                //
                //FONTFAMILY CHOICE
                Container(
                  height: 50,
                  width: 110,
                  decoration: BoxDecoration(
                    color:
                        data.isDarkMode ? Colors.black : ColorTheme.secondary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          isSelected: false,
                          height: 40,
                          width: 40,
                          borderRadius: 100,
                          color:
                              data.fontFamily == 'Poppins'
                                  ? ColorTheme.blue
                                  : ColorTheme.secondary,
                          spaceBetween: 0,
                          text: 'Aa',
                          alignment: MainAxisAlignment.center,
                          textColor: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          splashColor: const Color.fromARGB(86, 255, 255, 255),
                          onTap: () async {
                            if (data.fontFamily != 'Poppins') {
                              await widget.setPrefs(fontFamilyNew: 'Poppins');
                            }
                          },
                        ),
                        MyButton(
                          isSelected: false,
                          height: 40,
                          width: 40,
                          borderRadius: 100,
                          color:
                              data.fontFamily == 'Lora'
                                  ? ColorTheme.blue
                                  : ColorTheme.secondary,
                          text: 'Aa',
                          spaceBetween: 0,
                          alignment: MainAxisAlignment.center,
                          textColor: Colors.white,
                          fontFamily: 'Lora',
                          fontSize: 13,
                          splashColor: const Color.fromARGB(86, 255, 255, 255),
                          onTap: () async {
                            if (data.fontFamily != 'Lora') {
                              await widget.setPrefs(fontFamilyNew: 'Lora');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Text(
                    'A-',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        tickMarkShape: const RoundSliderTickMarkShape(
                          tickMarkRadius: 4,
                        ),
                      ),
                      child: Slider(
                        value: data.fontSize,
                        thumbColor: ColorTheme.blue,
                        activeColor: ColorTheme.blue,
                        inactiveColor: const Color.fromARGB(126, 255, 255, 255),
                        min: 12,
                        max: 24,
                        divisions: 6, // cria pontos fixos
                        label: data.fontSize.round().toString(),
                        onChanged: (value) {
                          widget.setPrefs(
                            fontFamilyNew: data.fontFamily,
                            isDarkModeNew: data.isDarkMode,
                            fontSizeNew: value,
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    'A+',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
