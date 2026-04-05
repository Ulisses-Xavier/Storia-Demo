import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/chapter/chapter_model.dart';
import 'package:storia/models/content/chapter/sections_model.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/chapter/chapter_repository.dart';
import 'package:storia/repositories/content/chapter/sections_repository.dart';
import 'package:storia/repositories/content/content_repository.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/content_display.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/popups/create_settings/create_settings_popup.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';
import 'package:uuid/uuid.dart';

class WebnovelChapterCreate extends ConsumerStatefulWidget {
  final String? chapterId; //Para edição e afins
  final ContentModel content;
  const WebnovelChapterCreate({
    super.key,
    required this.content,
    this.chapterId,
  });

  @override
  ConsumerState<WebnovelChapterCreate> createState() =>
      _WebnovelChapterCreateState();
}

class _WebnovelChapterCreateState extends ConsumerState<WebnovelChapterCreate> {
  //Controllers dos campos de webnovel
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  //Loading button & Editing data
  bool isAtualizarLoading = false;
  late String firstTitle;
  late String firstContent;
  late List<SectionsModel> listOfSectionsModel;
  ChapterModel? chapterToEdit;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    if (widget.chapterId != null) {
      loadChapterToEdit();

      _titleController.addListener(() {
        onTextChanged();
      });

      _contentController.addListener(() {
        onTextChanged();
      });
    }
  }

  List<String> processarTexto(String texto) {
    //Remover espaços e quebras desnecessárias no começo e fim
    String limpo = texto.trim();

    //Substituir múltiplas quebras de linha por uma única marca de parágrafo
    limpo = limpo.replaceAll(RegExp(r'\n\s*\n'), '<PARAGRAFO>');

    //Remover quebras simples e excesso de espaços dentro dos parágrafos
    limpo = limpo.replaceAll(RegExp(r'\n+'), ' ');
    limpo = limpo.replaceAll(RegExp(r'\s+'), ' ');

    //Separar novamente em parágrafos
    List<String> paragrafos = limpo.split('<PARAGRAFO>');

    //Limpar cada parágrafo e descartar os vazios
    paragrafos =
        paragrafos.map((p) => p.trim()).where((p) => p.isNotEmpty).toList();

    return paragrafos;
  }

  //Função para criar webnovel chapter
  Future<void> createWebnovelChapter(Map<String, dynamic> data) async {
    final uuid = Uuid();

    String title = data['title'];
    String rawContent = _contentController.text.trim();
    String status = data['status'];
    int chapterOrder = data['order'];
    DateTime? schedule = data['schedule'];

    final isEditingDraft =
        chapterToEdit != null && chapterToEdit!.status == 'rascunho';

    if (status != 'rascunho' && isEditingDraft) {
      final callable = FirebaseFunctions.instanceFor(
        region: "southamerica-east1",
      ).httpsCallable('publishDraftChapter');

      List<String> content = processarTexto(rawContent);
      List<Map<String, dynamic>> sections = [];

      int order = 0;
      for (String paragrafo in content) {
        order++;
        String sectionId = uuid.v4();
        sections.add({'id': sectionId, 'text': paragrafo, 'order': order});
      }

      try {
        await callable.call({
          'contentId': widget.content.id,
          'newOrder': chapterOrder,
          'status': status,
          'chapterId': chapterToEdit!.id,
          'sections': sections,
        });
        await ContentRepository().updateLastChapterDate(
          widget.content.id!,
          DateTime.now(),
        );
        return;
      } on FirebaseFunctionsException catch (e) {
        debugPrint('AQUIIII: ${e.toString()}');
        ref
            .read(snackBarProvider.notifier)
            .showMessage(
              SnackBarContent(
                message:
                    'Erro durante a atualização do capítulo | Tente novamente',
                error: true,
              ),
            );
        return;
      }
    }

    ChapterModel theChapter = ChapterModel(
      title: title,
      status: status,
      contentId: widget.content.id,
      publishAt: status == 'agendado' ? schedule : null,
    );
    final theData = theChapter.toJson();

    List<String> content = processarTexto(rawContent);
    List<Map<String, dynamic>> sections = [];

    if (status != 'rascunho') {
      int order = 0;
      for (String paragrafo in content) {
        order++;
        String sectionId = uuid.v4();
        sections.add({'id': sectionId, 'text': paragrafo, 'order': order});
      }
    }

    final callable = FirebaseFunctions.instanceFor(
      region: "southamerica-east1",
    ).httpsCallable('createAndAdjustChapters');
    try {
      await callable.call({
        'contentId': widget.content.id,
        'newOrder': chapterOrder,
        'chapterData': theData,
        'sections': sections,
      });
    } on FirebaseFunctionsException catch (_) {
      ref
          .read(snackBarProvider.notifier)
          .showMessage(
            SnackBarContent(
              message: 'Erro durante a criação do capítulo | Tente novamente',
              error: true,
            ),
          );
      return;
    }
    if (status == 'publicado') {
      await ContentRepository().updateLastChapterDate(
        widget.content.id!,
        DateTime.now(),
      );
    }
    return;
  }

  @override
  void dispose() {
    super.dispose();
    _handleExit();

    _titleController.dispose();
    _contentController.dispose();
  }

  //NOW IT'S TIME TO CREATE THE FEATURE OF SAVING RASCUNHOS
  Future<void> saveDraft() async {
    if (chapterToEdit == null) return;

    final contentId = widget.content.id;
    final chapterId = chapterToEdit!.id;

    ChapterModel? doc;

    doc = await ChapterRepository(contentId: contentId!).get(chapterId!);

    if (doc == null) return;

    final currentStatus = doc.status;

    if (currentStatus != 'rascunho') return;

    if (chapterToEdit != null && chapterToEdit!.status == 'rascunho') {
      final title = _titleController.text.trim();
      final text = _contentController.text.trim();

      final titleDifference = title != firstTitle;
      final textDifference = text != firstContent;
      if (titleDifference && textDifference) {
        await ChapterRepository(
          contentId: widget.content.id!,
        ).update(chapterToEdit!.id!, ChapterModel(title: title, rawText: text));
      } else if (titleDifference) {
        await ChapterRepository(
          contentId: widget.content.id!,
        ).update(chapterToEdit!.id!, ChapterModel(title: title));
      } else if (textDifference) {
        await ChapterRepository(
          contentId: widget.content.id!,
        ).update(chapterToEdit!.id!, ChapterModel(rawText: text));
      }
    }
  }

  Timer? _debounce;

  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 2), () async {
      try {
        await saveDraft();
      } catch (_) {
        return;
      }
    });
  }

  Future<void> _handleExit() async {
    if (widget.chapterId == null && chapterToEdit == null) {
      final title = _titleController.text.trim();
      final data = {'status': 'rascunho', 'title': title, 'order': 0};

      await createWebnovelChapter(data);
      return;
    }

    if (widget.chapterId != null &&
        chapterToEdit != null &&
        chapterToEdit!.status == 'rascunho') {
      await saveDraft();
    }
  }

  Future<void> loadChapterToEdit() async {
    if (widget.chapterId == null) return;
    try {
      final chapter = await ChapterRepository(
        contentId: widget.content.id!,
      ).get(widget.chapterId!);
      if (chapter != null) {
        final sectionsOfText =
            await SectionsRepository(
              contentId: widget.content.id!,
              chapterId: chapter.id!,
            ).getAll();
        String? text;
        if (sectionsOfText != null) {
          for (SectionsModel section in sectionsOfText) {
            if (text == null) {
              text = section.text;
            } else {
              text = '$text\n\n${section.text}';
            }
          }
        }
        setState(() {
          if (chapter.title != null) {
            _titleController.text = chapter.title!;
            firstTitle = chapter.title!;
          } else {
            firstTitle = '';
          }

          if (chapter.status == 'rascunho' && chapter.rawText != null) {
            firstContent = chapter.rawText!;
            _contentController.text = chapter.rawText ?? '';
          } else if (text != null) {
            _contentController.text = text;
            firstContent = text;
            listOfSectionsModel = sectionsOfText!;
          } else {
            firstContent = '';
          }

          chapterToEdit = chapter;
        });
      }
    } catch (e) {
      ref
          .read(snackBarProvider.notifier)
          .showMessage(
            SnackBarContent(
              message: 'Houve um erro ao carregar o capítulo | Tente novamente',
              error: true,
            ),
          );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          //
          //
          //Topo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyButton(
                    alignment: MainAxisAlignment.center,
                    isSelected: false,
                    height: 40,
                    width: 40,
                    borderRadius: 10,
                    color: DashboardTheme.secondary,
                    border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
                    splashColor: const Color.fromARGB(57, 255, 255, 255),
                    onHover: DashboardTheme.blue,
                    icon: LucideIcons.arrowLeft100,
                    iconSize: 15,
                    spaceBetween: 0,
                    onTap: () async {
                      context.pop();
                    },
                  ),
                  SizedBox(width: 6),
                  ContentDisplay(content: widget.content),
                ],
              ),

              MyButton(
                alignment: MainAxisAlignment.center,
                isSelected: false,
                height: 40,
                isLoading: isAtualizarLoading,
                loadingSize: 0.5,
                loadingColor: Colors.white,
                width: 120,
                color: DashboardTheme.blue,
                splashColor: const Color.fromARGB(57, 255, 255, 255),
                onHover: DashboardTheme.blue,
                text:
                    widget.chapterId != null &&
                            (chapterToEdit != null &&
                                chapterToEdit!.status != 'rascunho')
                        ? 'Atualizar'
                        : 'Continuar',
                fontSize: 15,
                borderRadius: 10,
                textColor: Colors.white,
                onTap: () async {
                  final snackBar = ref.read(snackBarProvider.notifier);
                  if (_titleController.text.isEmpty) {
                    snackBar.showMessage(
                      SnackBarContent(
                        message: 'Por favor, insira um título',
                        error: true,
                      ),
                    );
                    return;
                  }

                  //Se o campo de conteúdo estiver muito curto
                  if (_contentController.text.length <= 200) {
                    snackBar.showMessage(
                      SnackBarContent(
                        message: 'Seu texto tem menos de 200 caracteres',
                        error: true,
                      ),
                    );
                    return;
                  }

                  if (_contentController.text.length > 800000) {
                    snackBar.showMessage(
                      SnackBarContent(
                        message: 'Seu texto é muito grande',
                        error: true,
                      ),
                    );
                    return;
                  }

                  if (widget.chapterId != null &&
                      !isAtualizarLoading &&
                      chapterToEdit != null &&
                      chapterToEdit!.status != 'rascunho') {
                    try {
                      setState(() {
                        isAtualizarLoading = true;
                      });
                      final title = _titleController.text.trim();
                      final text = _contentController.text.trim();

                      final titleDifference = title != firstTitle;
                      final textDifference = text != firstContent;

                      String? titleToUpdate;
                      List<Map<String, dynamic>> sectionsToUpdate = [];

                      if (titleDifference) {
                        titleToUpdate = title;
                      }

                      if (textDifference) {
                        List<String> content = processarTexto(text);

                        final uuid = Uuid();

                        int order = 0;
                        for (String paragrafo in content) {
                          order++;
                          String sectionId = uuid.v4();
                          sectionsToUpdate.add({
                            'id': sectionId,
                            'text': paragrafo,
                            'order': order,
                          });
                        }
                      }

                      if (titleDifference || textDifference) {
                        final callable = FirebaseFunctions.instance
                            .httpsCallable('updateChapterSections');
                        await callable.call({
                          'contentId': widget.content.id,
                          'chapterId': chapterToEdit!.id,
                          'sections': sectionsToUpdate,
                          'title': titleToUpdate,
                        });
                      }

                      setState(() {
                        isAtualizarLoading = false;
                      });
                      snackBar.showMessage(
                        SnackBarContent(
                          message: 'Conteúdo atualizado com sucesso',
                          error: false,
                        ),
                      );
                      context.pop();
                    } catch (_) {
                      setState(() {
                        isAtualizarLoading = false;
                      });
                      return;
                    }
                  }

                  Map<String, dynamic> data = {
                    'title': _titleController.text.trim(),
                    'rawContent': _contentController.text,
                    'contentId': widget.content.id!,
                  };

                  final navigate = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) {
                      return CreateSettingPopup(
                        content: widget.content,
                        chapter: ChapterModel(title: _titleController.text),
                        function: createWebnovelChapter,
                        data: data,
                      );
                    },
                  );

                  if (navigate != null && navigate['navigate']) {
                    context.pop();
                  }
                },
              ),
            ],
          ),

          SizedBox(height: 10),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: DashboardTheme.secondary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8,
                            left: 8,
                            top: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: _titleController,
                                  height: 60,
                                  backgroundColor: Colors.transparent,
                                  tipText: 'Título...',
                                  textColor: Colors.white,
                                  maxLines: 1,
                                  fontSize: 25,
                                  distanceBetween: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MyTextField(
                            controller: _contentController,
                            backgroundColor: Colors.transparent,
                            tipText: 'Escreva aqui...',
                            textColor: Colors.white,
                            fontSize: 15,

                            distanceBetween: 0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
