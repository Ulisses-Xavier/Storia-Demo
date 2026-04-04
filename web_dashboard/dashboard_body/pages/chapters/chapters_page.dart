import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/chapter/chapter_model.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/chapter/chapter_repository.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/chapter_display.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/chapter_manipulate.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/container_responses/error.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/container_responses/no_chapters.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/editing_button.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/search_bar.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/top_bar/content_select.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/top_bar/status_select.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/no_works.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class ChaptersPage extends ConsumerStatefulWidget {
  final Widget child;
  const ChaptersPage({super.key, required this.child});

  @override
  ConsumerState<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends ConsumerState<ChaptersPage> {
  bool editing = false;
  ContentModel? content;
  String? warn;

  //SEARCHING\\
  bool searching = false;
  List<ChapterModel> searchedChapters = [];

  //Capítulos\\
  List<ChapterModel> theChapters = [];
  List<ChapterModel> chaptersBedoreEditing = [];
  List<Map<String, dynamic>> jsonChapters = [];
  String? lastChapterManipulated;

  //Capítulos de ordem alterada\\
  List<Map<String, dynamic>> editedChapters = [];

  //InitState\\
  @override
  void initState() {
    super.initState();
  }

  //Set Content\\
  void setContent(ContentModel newContent, currentStatus) {
    if (!mounted) return;
    setState(() {
      content = newContent;
      warn = null;

      jsonChapters.clear();
    });
  }

  //Set error
  void setWarn(String newWarn) {
    if (!mounted) return;
    setState(() {
      warn = newWarn;
      content = null;
    });
  }

  void editingToggle(bool newValue) {
    if (newValue) {
      setState(() {
        editing = true;
      });
    } else {
      setState(() {
        editing = false;
      });
    }
  }

  void resetLastChapterManipulated(dynamic nothing) {
    lastChapterManipulated = null;
  }

  //FUNÇÕES DE SEARCHING
  void setSearching(String text) {
    setState(() {
      searching = true;
      searchedChapters = [];
    });
    for (ChapterModel chapter in theChapters) {
      if (chapter.title!.toLowerCase().contains(text.toLowerCase())) {
        searchedChapters.add(chapter);
      }
    }
  }

  void offSearching(bool state) {
    setState(() {
      searching = false;
      searchedChapters = [];
    });
  }

  //============================================\\
  //Funções de manipulação de ordem dos capítulos
  //============================================\\
  void downOrder(int index) {
    if (index == jsonChapters.length - 1) return; // não pode descer mais

    setState(() {
      final current = jsonChapters[index];
      final next = jsonChapters[index + 1];

      // swap das ordens
      final temp = current['order'];
      current['order'] = next['order'];
      next['order'] = temp;

      // swap visual na lista
      jsonChapters[index] = next;
      jsonChapters[index + 1] = current;

      lastChapterManipulated = current['id'];

      // garantir ordenação
      jsonChapters.sort((a, b) => (a['order']).compareTo(b['order']));

      //---Checando chapters editados---\\
      List<Map<String, dynamic>> chaptersToSet = [];
      for (var chapter in jsonChapters) {
        for (var chapterBE in chaptersBedoreEditing) {
          if (chapter['id'] == chapterBE.id) {
            if (chapter['order'] != chapterBE.order) {
              chaptersToSet.add({
                'chapterId': chapter['id'],
                'newOrder': chapter['order'],
              });
            }
          }
        }
      }
      editedChapters = chaptersToSet;
    });
  }

  void upOrder(int index) {
    if (index == 0) return; // não pode subir mais

    setState(() {
      final current = jsonChapters[index];
      final previous = jsonChapters[index - 1];

      // swap das ordens
      final temp = current['order'];
      current['order'] = previous['order'];
      previous['order'] = temp;

      // swap visual na lista
      jsonChapters[index] = previous;
      jsonChapters[index - 1] = current;

      lastChapterManipulated = current['id'];

      // garantir ordenação
      jsonChapters.sort((a, b) => (a['order']).compareTo(b['order']));

      //---Checando chapters editados---\\
      List<Map<String, dynamic>> chaptersToSet = [];
      for (var chapter in jsonChapters) {
        for (var chapterBE in chaptersBedoreEditing) {
          if (chapter['id'] == chapterBE.id) {
            if (chapter['order'] != chapterBE.order) {
              chaptersToSet.add({
                'chapterId': chapter['id'],
                'newOrder': chapter['order'],
              });
            }
          }
        }
      }
      editedChapters = chaptersToSet;
    });
  }

  //loading button
  bool isLoading = false;

  //==========================\\
  //----------BUILD-----------\\
  //==========================\\

  @override
  Widget build(BuildContext context) {
    //----------Path-State-----------\\
    String path = GoRouter.of(context).state.uri.toString();
    String status =
        path.contains('publicados')
            ? 'publicado'
            : (path.contains('agendados') ? 'agendado' : 'rascunho');

    if (editing == true && status != 'publicado') {
      editingToggle(false);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Barra de filtro de status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusSelect(),
                ContentSelect(
                  setcontent: setContent,
                  setWarn: setWarn,
                  status: status,
                ),
              ],
            ),

            SizedBox(height: 15),

            //Segunda Row vertical
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ChaptersSearchBar(
                      setSearching: setSearching,
                      offSearching: offSearching,
                      searching: searching,
                    ),
                    SizedBox(width: 3),

                    //Botão de Edição de order
                    EditingButton(
                      editingToggle: editingToggle,
                      editing: editing,
                      isPublished: path.contains('publicados'),
                      resetLastChapterManipulated: resetLastChapterManipulated,
                    ),
                  ],
                ),
                MyButton(
                  isSelected: false,
                  color: DashboardTheme.blue,
                  height: 40,
                  width: 70,
                  textColor: Colors.white,
                  borderRadius: 10,
                  rightIcon: LucideIcons.plus,
                  spaceBetween: 0,
                  onHover: const Color.fromARGB(255, 42, 70, 142),
                  alignment: MainAxisAlignment.center,
                  splashColor: Colors.transparent,
                  iconSize: 15,
                  fontSize: 15,
                  onTap: () {
                    if (content != null) {
                      context.push('/dashboard/capitulos/${content!.id}/criar');
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            //==================\\
            //    CHAPTER LIST
            //==================\\
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: DashboardTheme.secondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 42, 42, 42),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(30, 5, 5, 5),
                    blurRadius: 5,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child:
                  (warn == 'no content')
                      ? const NoWorks()
                      : (warn == 'error')
                      ? const LoadError()
                      : (content == null)
                      ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: DashboardTheme.blue,
                            ),
                          ),
                        ),
                      )
                      : FutureBuilder<List<ChapterModel>?>(
                        future: ChapterRepository(
                          contentId: content!.id!,
                        ).getChapterByStatus(status, false, ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              !editing) {
                            return SizedBox(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: DashboardTheme.blue,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            debugPrint('ERROR: ${snapshot.error.toString()}');
                            return SizedBox(
                              height: 100,
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

                          if (snapshot.data == null) {
                            return NoChapters();
                          }

                          final theData = snapshot.data;
                          final chapters =
                              theData!
                                ..sort((a, b) => a.order!.compareTo(b.order!));

                          if (editing) {
                            chaptersBedoreEditing = chapters;
                          }

                          //Para o searching
                          theChapters = chapters;

                          //Para o Editing
                          jsonChapters =
                              chapters.map((e) => e.toJson()).toList()..sort(
                                (a, b) => a['order'].compareTo(b['order']),
                              );

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                if (searchedChapters.isEmpty && searching)
                                  NoChapters(),

                                ListView.builder(
                                  itemCount:
                                      searching
                                          ? searchedChapters.length
                                          : chapters.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final chapter =
                                        searching
                                            ? searchedChapters[index]
                                            : chapters[index];
                                    final jsonChapter = jsonChapters[index];

                                    if (editing) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: ChapterManipulate(
                                          chapter: jsonChapter,
                                          upOrder: upOrder,
                                          downOrder: downOrder,
                                          index: index,
                                          manipulateAll: true,
                                          isHighlighted:
                                              lastChapterManipulated ==
                                              jsonChapter['id'],
                                        ),
                                      );
                                    }

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: ChapterDisplay(
                                        chapter: chapter,
                                        showStatus: false,
                                        showOrder:
                                            chapter.status == 'rascunho'
                                                ? false
                                                : true,
                                        content: content,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
            SizedBox(height: 20),
            if (editing && editedChapters.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    isSelected: false,
                    height: 35,
                    width: 90,
                    text: 'Salvar',
                    fontSize: 13,
                    color: DashboardTheme.blue,
                    isLoading: isLoading,
                    loadingWidth: 5,
                    loadingSize: 0.5,
                    loadingColor: Colors.white,
                    borderRadius: 10,
                    alignment: MainAxisAlignment.center,
                    onHover: DashboardTheme.blue,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      //Clound Funcion\\
                      final functions = FirebaseFunctions.instance;

                      final reorderChapters = functions.httpsCallable(
                        'reorderPublishedChapters',
                      );
                      try {
                        final result = await reorderChapters.call({
                          'contentId': content!.id,
                          'updates': editedChapters, // lista que você montou
                        });

                        // sucesso
                        final data = result.data;
                        if (data['ok']) {
                          ref
                              .read(snackBarProvider.notifier)
                              .showMessage(
                                SnackBarContent(
                                  message: 'Reordenação completa',
                                  error: false,
                                ),
                              );
                        }
                        setState(() {
                          isLoading = false;
                          editing = false;
                          editedChapters = [];
                        });
                        return;
                      } on FirebaseFunctionsException catch (_) {
                        ref
                            .read(snackBarProvider.notifier)
                            .showMessage(
                              SnackBarContent(
                                message: 'Falha ao reordenar | Tente novamente',
                                error: true,
                              ),
                            );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
