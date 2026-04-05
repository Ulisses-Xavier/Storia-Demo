import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/mobile/app/sub_pages/chapter_page.dart/chapter_page_widgets/chapter_page_app_bar.dart';
import 'package:storia/mobile/app/sub_pages/chapter_page.dart/chapter_page_widgets/chapter_page_bottom_bar.dart';
import 'package:storia/mobile/app/sub_pages/chapter_page.dart/chapter_page_widgets/preferences_riverpod.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/chapter/sections_model.dart';
import 'package:storia/repositories/content/chapter/chapter_repository.dart';
import 'package:storia/repositories/content/chapter/sections_repository.dart';
import 'package:storia/repositories/shared_preferences/reader_preferences.dart';

class ChapterPage extends ConsumerStatefulWidget {
  final String contentId;
  final int chapterNumber;
  const ChapterPage({
    super.key,
    required this.contentId,
    required this.chapterNumber,
  });

  @override
  ConsumerState<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends ConsumerState<ChapterPage> {
  late Future<Map<String, dynamic>?> future;

  //Scroll Config
  double lastOffset = 0;
  late final ScrollController _controller;
  double accumulatedScroll = 0;
  bool showUi = true;
  static const double threshold = 20;

  //Reader Theme Data
  double fontSize = 16;
  bool isDarkMode = false;
  String fontFamily = 'Poppins';

  //
  //
  //CARREGA O CONTEÚDO NECESSÁRIO PRA PÁGINA\\
  Future<Map<String, dynamic>?> loadContent({int? theOrder}) async {
    final order = theOrder ?? widget.chapterNumber;
    final nextOrder = order + 1;
    final previousOrder = order - 1;
    final chapter = await ChapterRepository(
      contentId: widget.contentId,
    ).getByOrder(order);

    if (chapter == null) {
      return null;
    }

    final chapterContent =
        await SectionsRepository(
          contentId: widget.contentId,
          chapterId: chapter.id!,
        ).getAll();

    final nextChapter = await ChapterRepository(
      contentId: widget.contentId,
    ).getByOrder(nextOrder);

    final previousChapter = await ChapterRepository(
      contentId: widget.contentId,
    ).getByOrder(previousOrder);

    final next = nextChapter != null ? nextChapter.order : nextChapter;
    final previous =
        previousChapter != null ? previousChapter.order : previousChapter;

    return {
      'title': chapter.title,
      'chapterContent': chapterContent,
      'next': next,
      'previous': previous,
      'order': theOrder ?? widget.chapterNumber,
    };
  }

  @override
  void initState() {
    future = loadContent();
    _controller = ScrollController();
    _loadPrefs();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setFuture(int order) {
    setState(() {
      future = loadContent(theOrder: order);
    });
  }

  void _loadPrefs() async {
    fontSize = await ReaderPreferences.getFontSize();
    isDarkMode = await ReaderPreferences.getTheme();
    fontFamily = await ReaderPreferences.getFontFamily();
    ref
        .read(preferencesNotifier.notifier)
        .set(
          PreferencesState(
            isDarkMode: isDarkMode,
            fontSize: fontSize,
            fontFamily: fontFamily,
          ),
        );
    setState(() {});
  }

  Future<void> setPrefs({
    bool? isDarkModeNew,
    double? fontSizeNew,
    String? fontFamilyNew,
  }) async {
    if (isDarkModeNew != null) {
      setState(() {
        isDarkMode = isDarkModeNew;
      });
      await ReaderPreferences.setTheme(isDarkModeNew);
      ref
          .read(preferencesNotifier.notifier)
          .set(
            PreferencesState(
              isDarkMode: isDarkMode,
              fontSize: fontSize,
              fontFamily: fontFamily,
            ),
          );
    }

    if (fontSizeNew != null) {
      setState(() {
        fontSize = fontSizeNew;
      });

      await ReaderPreferences.setFontSize(fontSizeNew);
      ref
          .read(preferencesNotifier.notifier)
          .set(
            PreferencesState(
              isDarkMode: isDarkMode,
              fontSize: fontSize,
              fontFamily: fontFamily,
            ),
          );
    }

    if (fontFamilyNew != null) {
      setState(() {
        fontFamily = fontFamilyNew;
      });
      await ReaderPreferences.setFontFamily(fontFamilyNew);
      ref
          .read(preferencesNotifier.notifier)
          .set(
            PreferencesState(
              isDarkMode: isDarkMode,
              fontSize: fontSize,
              fontFamily: fontFamily,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: ColorTheme.blue),
            );
          }

          final Map<String, dynamic>? data = snapshot.data;

          if (snapshot.hasError) {
            return Container(height: 100, width: 100, color: Colors.red);
          }

          if (data == null) {
            return Container(height: 100, width: 100, color: Colors.amber);
          }

          return Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: Stack(
              children: [
                //
                //
                //
                //
                //CONFIGURAÇÃO DO SCROLL\\
                //
                GestureDetector(
                  onTap:
                      () => setState(() {
                        showUi = !showUi;
                      }),
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(overscroll: false),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        final currentOffset = notification.metrics.pixels;
                        final delta = currentOffset - lastOffset;

                        // Acumula movimento na mesma direção
                        accumulatedScroll += delta;

                        if (accumulatedScroll.abs() > threshold) {
                          if (accumulatedScroll > 0 && showUi) {
                            // Scroll para baixo
                            setState(() => showUi = false);
                          }

                          if (accumulatedScroll < 0 && !showUi) {
                            // Scroll para cima
                            setState(() => showUi = true);
                          }

                          accumulatedScroll = 0; // reseta após acionar
                        }

                        lastOffset = currentOffset;

                        return true;
                      },
                      //
                      //
                      //
                      //
                      //
                      //EXIBIÇÃO DO TEXTO\\  <-----
                      child: Padding(
                        padding: EdgeInsets.only(top: !showUi ? 40 : 75),
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: data['chapterContent'].length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          itemBuilder: (context, index) {
                            final SectionsModel section =
                                data['chapterContent'][index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                softWrap: true,
                                section.text!,
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.white
                                          : Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: fontFamily,
                                  fontSize: fontSize,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (showUi)
                  ChapterPageAppBar(
                    title: data['title'],
                    order: data['order'],
                    showUi: showUi,
                    setPrefs: setPrefs,
                  ),
                if (showUi)
                  ChapterPageBottomBar(
                    showUi: showUi,
                    contentId: widget.contentId,
                    next: data['next'],
                    previous: data['previous'],
                    setFuture: setFuture,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
