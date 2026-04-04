import 'package:flutter/material.dart';
import 'package:storia/models/content/chapter/chapter_model.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/chapter/chapter_repository.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/popups/create_settings/widgets/schedule_set.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/chapter_manipulate.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

typedef ChapterAction = Future<void> Function(Map<String, dynamic> data);

class CreateSettingPopup extends StatefulWidget {
  final ChapterModel chapter;
  final ContentModel content;
  final ChapterAction function;
  final Map<String, dynamic> data;
  const CreateSettingPopup({
    super.key,
    required this.content,
    required this.chapter,
    required this.function,
    required this.data,
  });

  @override
  State<CreateSettingPopup> createState() => _CreateSettingPopupState();
}

class _CreateSettingPopupState extends State<CreateSettingPopup> {
  bool isLoading = false;
  late bool publishNow;
  late Future<List<ChapterModel>?> futureChapters;
  late int chapterOrder;
  late DateTime date;
  late TimeOfDay hour;
  List<Map<String, dynamic>> scheduledChaptersData = [];

  List<Map<String, dynamic>> chaptersMap = [];

  void downOrder(int index, {List<Map<String, dynamic>>? list}) {
    if (index >= chaptersMap.length - 1) return;

    setState(() {
      final current = chaptersMap[index];
      final next = chaptersMap[index + 1];

      // swap das ordens
      final currentOrder = current['order'];
      final nextOrder = next['order'];

      current['order'] = nextOrder;
      next['order'] = currentOrder;

      // atualizar scheduledChaptersData (se existir)
      final scheduledIndex = scheduledChaptersData.indexWhere(
        (c) => identical(c, next),
      );
      if (scheduledIndex != -1) {
        scheduledChaptersData[scheduledIndex]['order'] = currentOrder;
      }

      // swap visual
      chaptersMap[index] = next;
      chaptersMap[index + 1] = current;

      // sort FINAL (agora consistente)
      chaptersMap.sort((a, b) => a['order'].compareTo(b['order']));

      // ordem real do capítulo principal
      final main = chaptersMap.firstWhere(
        (c) => c['isMain'] == true,
        orElse: () => {},
      );
      if (main.isNotEmpty) {
        chapterOrder = main['order'];
      }
    });
  }

  void upOrder(int index, {List<Map<String, dynamic>>? list}) {
    if (index <= 0) return;

    setState(() {
      final current = chaptersMap[index];
      final previous = chaptersMap[index - 1];

      // swap das ordens
      final currentOrder = current['order'];
      final previousOrder = previous['order'];

      current['order'] = previousOrder;
      previous['order'] = currentOrder;

      // atualizar scheduledChaptersData (se existir)
      final scheduledIndex = scheduledChaptersData.indexWhere(
        (c) => identical(c, previous),
      );
      if (scheduledIndex != -1) {
        scheduledChaptersData[scheduledIndex]['order'] = currentOrder;
      }

      // swap visual
      chaptersMap[index] = previous;
      chaptersMap[index - 1] = current;

      // sort FINAL (agora consistente)
      chaptersMap.sort((a, b) => a['order'].compareTo(b['order']));

      // ordem real do capítulo principal
      final main = chaptersMap.firstWhere(
        (c) => c['isMain'] == true,
        orElse: () => {},
      );
      if (main.isNotEmpty) {
        chapterOrder = main['order'];
      }
    });
  }

  @override
  void initState() {
    super.initState();

    publishNow = true;
    date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    hour = TimeOfDay.now();

    futureChapters = ChapterRepository(
      contentId: widget.content.id!,
    ).getChapterByStatus('publicado', true, 'agendado');

    futureChapters = ChapterRepository(
      contentId: widget.content.id!,
    ).getChapterByStatus('publicado', true, 'agendado');

    futureChapters.then((chapters) {
      if (chapters != null) {
        int biggestOrder = 0;

        for (ChapterModel c in chapters) {
          if (c.order! > biggestOrder) biggestOrder = c.order!;

          Map<String, dynamic> chapterToAdd = {
            'title': c.title,
            'order': c.order,
            'status': c.status,
            'isMain': false,
            'id': c.id,
            'publishAt': c.publishAt,
          };

          chaptersMap.add(chapterToAdd);

          if (c.status == 'agendado') {
            scheduledChaptersData.add(chapterToAdd);
          }
        }
        chapterOrder = biggestOrder + 1;

        // Primeiro vem o capítulo sendo criado
        chaptersMap.add({
          'title': widget.chapter.title,
          'order': chapterOrder,
          'isMain': true,
        });

        chaptersMap.sort(
          (chapter, b) => (chapter['order'] ?? 0).compareTo(b['order'] ?? 0),
        );
      }
    });
  }

  void setDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void setTime(TimeOfDay newHour) {
    setState(() {
      hour = newHour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: DashboardTheme.primary,
                border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    //
                    //
                    //
                    //
                    //Selecionar ordem
                    Text(
                      'Selecione a ordem do capítulo:',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DashboardTheme.secondary,
                        border: Border.all(
                          color: Color.fromARGB(255, 42, 42, 42),
                        ),
                      ),
                      child: FutureBuilder<List<ChapterModel>?>(
                        future: futureChapters,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError) {
                            return SizedBox(
                              height: 60,
                              child: const Center(
                                child: Text(
                                  'Erro ao carregar capítulos.',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            chapterOrder = 1;
                            return SizedBox(
                              height: 60,
                              child: Center(
                                child: Text(
                                  'Este é o primeiro capítulo',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            );
                          }

                          //Manipulação de ordem do capítulo
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              height: 400,
                              child: ListView.builder(
                                itemCount: chaptersMap.length,
                                itemBuilder: (context, index) {
                                  //
                                  //
                                  Map<String, dynamic> theChapter =
                                      chaptersMap[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                      top: index == 0 ? 8 : 0,
                                    ),
                                    child: ChapterManipulate(
                                      chapter: theChapter,
                                      upOrder: upOrder,
                                      downOrder: downOrder,
                                      index: index,
                                      manipulateAll: false,
                                    ),
                                  );
                                },
                                //
                                //
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //
                    //
                    //
                    //
                    //
                    //
                    //
                    //Quando publicar
                    SizedBox(height: 10),
                    Text(
                      'Quando deseja publicar?',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyButton(
                              isSelected: publishNow,
                              text: 'Agora',
                              color: Colors.transparent,
                              height: 35,
                              width: 100,
                              selectedColor: DashboardTheme.blue,
                              textColor: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              border:
                                  publishNow != true
                                      ? Border.all(
                                        color: Color.fromARGB(255, 42, 42, 42),
                                      )
                                      : null,
                              borderRadius: 10,
                              onHover: const Color.fromARGB(101, 62, 62, 62),
                              alignment: MainAxisAlignment.center,
                              splashColor: const Color.fromARGB(
                                31,
                                255,
                                255,
                                255,
                              ),
                              onTap: () {
                                if (!publishNow) {
                                  setState(() {
                                    publishNow = true;
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 5),
                            MyButton(
                              isSelected: !publishNow,
                              text: 'Agendar',
                              color: Colors.transparent,
                              height: 35,
                              width: 100,
                              selectedColor: DashboardTheme.blue,
                              textColor: Colors.white,
                              fontSize: 13,
                              border:
                                  publishNow != false
                                      ? Border.all(
                                        color: Color.fromARGB(255, 42, 42, 42),
                                      )
                                      : null,
                              fontFamily: 'Poppins',
                              borderRadius: 10,
                              onHover: const Color.fromARGB(101, 62, 62, 62),
                              alignment: MainAxisAlignment.center,
                              splashColor: const Color.fromARGB(
                                31,
                                255,
                                255,
                                255,
                              ),
                              onTap: () {
                                if (publishNow) {
                                  setState(() {
                                    publishNow = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        if (!publishNow)
                          ScheduleSet(
                            currentDate: DateTime(
                              date.year,
                              date.month,
                              date.day,
                              hour.hour,
                              hour.minute,
                            ),
                            date: setDate,
                            time: setTime,
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    //
                    //
                    //
                    //
                    //Botões finais
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: MyButton(
                            isSelected: false,
                            text: 'Cancelar',
                            color: Colors.transparent,
                            height: 40,
                            textColor: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            border: Border.all(
                              color: Color.fromARGB(255, 42, 42, 42),
                            ),
                            borderRadius: 10,
                            splashColor: const Color.fromARGB(
                              31,
                              255,
                              255,
                              255,
                            ),
                            onHover: const Color.fromARGB(8, 62, 62, 62),
                            alignment: MainAxisAlignment.center,
                            onTap: () {
                              Navigator.pop(context, {'navigate': false});
                            },
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: MyButton(
                            isSelected: false,
                            text: isLoading ? null : 'Continuar',
                            color: DashboardTheme.blue,
                            height: 40,
                            textColor: Colors.white,
                            loadingColor: Colors.white,
                            isLoading: isLoading,
                            loadingSize: 0.5,
                            spaceBetween: 0,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            borderRadius: 10,
                            splashColor: const Color.fromARGB(
                              57,
                              255,
                              255,
                              255,
                            ),
                            onHover: DashboardTheme.blue,
                            alignment: MainAxisAlignment.center,
                            onTap: () async {
                              setState(() => isLoading = true);
                              DateTime currentDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                hour.hour,
                                hour.minute,
                              );

                              final data = {
                                ...widget.data,
                                'order': chapterOrder,
                                'publishNow': publishNow,
                                'schedule': currentDate,
                                'status': publishNow ? 'publicado' : 'agendado',
                              };
                              try {
                                await widget.function(data);
                              } catch (_) {}
                              setState(() => isLoading = false);

                              Navigator.pop(context, {'navigate': true});
                            },
                          ),
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
