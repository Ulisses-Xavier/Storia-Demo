import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/models/tags_model.dart';
import 'package:storia/repositories/content/content_repository.dart';
import 'package:storia/repositories/tags_repository.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/widgets/cover_upload/cover_upload.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/widgets/long_cover_upload/long_cover_upload.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/widgets/main_tag.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/widgets/tags_options.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';
import 'package:uuid/uuid.dart';

class WorkCreationPage extends ConsumerStatefulWidget {
  final String? contentId;
  const WorkCreationPage({super.key, this.contentId});

  @override
  ConsumerState<WorkCreationPage> createState() => _WorkCreationPageState();
}

class _WorkCreationPageState extends ConsumerState<WorkCreationPage> {
  //VARIÁVEIS PARA EDIÇÃO
  ContentModel? contentToEdit;
  bool useImageFromContentToEdit = true;
  bool useLongImageFromContentToEdit = true;

  Uint8List? image;
  Uint8List? longImage;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool isLoadingButton = false;
  String? title;
  bool useMainCover = true;

  //LONG COVER DATA COLORS
  late final TextEditingController _rRGBController;
  late final TextEditingController _gRGBController;
  late final TextEditingController _bRGBController;
  int rRGB = 0;
  int gRGB = 0;
  int bRGB = 0;

  late Future<List<TagsModel>?> tagsFuture;
  TagsModel? mainTag;
  List<TagsModel> tagsList = [];
  String contentType = 'webnovel';

  @override
  void initState() {
    super.initState();
    //Se tiver id, editar
    if (widget.contentId != null) {
      loadContent();
    }
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    //LONG COVER DEFINITIONS
    _gRGBController = TextEditingController();
    _rRGBController = TextEditingController();
    _bRGBController = TextEditingController();

    _rRGBController.addListener(() {
      if (_rRGBController.text.trim().isNotEmpty) {
        setState(() {
          rRGB = int.parse(_rRGBController.text.trim());
        });
      } else {
        setState(() {
          rRGB = 0;
        });
      }
    });

    _gRGBController.addListener(() {
      if (_gRGBController.text.trim().isNotEmpty) {
        setState(() {
          gRGB = int.parse(_gRGBController.text.trim());
        });
      } else {
        setState(() {
          gRGB = 0;
        });
      }
    });

    _bRGBController.addListener(() {
      if (_bRGBController.text.trim().isNotEmpty) {
        setState(() {
          bRGB = int.parse(_bRGBController.text.trim());
        });
      } else {
        setState(() {
          bRGB = 0;
        });
      }
    });

    //Recebe e adiciona as tags em tagsFuture as tags
    tagsFuture = TagsRepository().getAll();

    //Listenter de title
    _titleController.addListener(() {
      setState(() {
        title = _titleController.text;
      });
    });
  }

  //FUNCTION TO LOAD THE CONTENT TO EDIT
  Future<void> loadContent() async {
    final String contentId = widget.contentId!;
    try {
      final content = await ContentRepository().get(contentId);

      if (content != null) {
        List<TagsModel> tagsModelList = [];
        TagsModel? mainTagToSet;

        for (Map tag in content.tags!) {
          final tagModel = await TagsRepository().get(tag['id']);
          if (tagModel != null) {
            tagsModelList.add(tagModel);
            if (tagModel.id == content.mainTag!['id']) {
              mainTagToSet = tagModel;
            }
          }
        }

        setState(() {
          contentToEdit = content;
          tagsList = tagsModelList;
          mainTag = mainTagToSet;

          _titleController.text = content.title!;
          _rRGBController.text = content.rgbColor!['r']!.toString();
          _gRGBController.text = content.rgbColor!['g']!.toString();
          _bRGBController.text = content.rgbColor!['b']!.toString();
          _descriptionController.text = content.description!;
        });
      }
    } catch (_) {}
  }

  void useMainCoverToggle() {
    setState(() {
      useMainCover = !useMainCover;
    });
  }

  void deleteLongCover() {
    setState(() {
      longImage = null;
    });
  }

  void useImageFromContentToEditToggle() {
    setState(() {
      useImageFromContentToEdit = !useImageFromContentToEdit;
    });
  }

  void useLongImageFromContentToEditToggle() {
    setState(() {
      useLongImageFromContentToEdit = !useLongImageFromContentToEdit;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _bRGBController.dispose();
    _gRGBController.dispose();
    _rRGBController.dispose();
    super.dispose();
  }

  //Adicionar tag
  void addTag(TagsModel tag) {
    setState(() {
      tagsList.add(tag);
    });
  }

  //Remover tag
  void removeTag(TagsModel tag) {
    setState(() {
      tagsList.removeWhere((t) => t.id == tag.id);
    });
  }

  //Remover último
  void removeLast(bool remove) {
    setState(() {
      tagsList.removeLast();
    });
  }

  void setMainTag(TagsModel tag) {
    mainTag = tag;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //COMIC CONTENT
            //TopBanner(
            //  changeContentType: (String newContentType) {
            //    contentType = newContentType;
            //  },
            //),
            //SizedBox(height: 20),

            //Título da Obra
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Título:',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 7),
                MyTextField(
                  controller: _titleController,
                  height: 50,
                  maxLines: 1,
                  border: Border.all(
                    color: const Color.fromARGB(255, 42, 42, 42),
                  ),
                  width: double.infinity,
                  backgroundColor: DashboardTheme.secondary,
                  borderRadius: 10,
                  cursorColor: DashboardTheme.blue,
                  tipText: 'Qual o nome da sua obra?',
                  hintColor: Color.fromARGB(198, 107, 107, 107),
                ),
              ],
            ),

            SizedBox(height: 20),

            //Descrição da Obra
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descrição(sinopse):',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 7),
                MyTextField(
                  controller: _descriptionController,
                  height: 200,
                  width: double.infinity,
                  backgroundColor: DashboardTheme.secondary,
                  borderRadius: 10,
                  cursorColor: DashboardTheme.blue,
                  maxLines: 30,
                  border: Border.all(
                    color: const Color.fromARGB(255, 42, 42, 42),
                  ),
                  tipText: 'Por favor, insira uma descrição...',
                  hintColor: Color.fromARGB(198, 107, 107, 107),
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ],
            ),

            SizedBox(height: 20),

            //Tags Options
            TagsOptions(
              future: tagsFuture,
              tagsList: tagsList,
              addTag: addTag,
              removeTag: removeTag,
              removeLast: removeLast,
            ),
            SizedBox(height: 20),

            //Main Tag
            MainTag(items: tagsList, setMainTag: setMainTag, mainTag: mainTag),
            SizedBox(height: 20),

            Text(
              'Insira uma capa:',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),

            SizedBox(height: 10),

            CoverUpload(
              image: (Uint8List newImage) {
                setState(() {
                  image = newImage;
                });
              },
              deleteImage: () {
                setState(() {
                  image = null;
                });
              },
              contentToEdit: contentToEdit,
              useImageFromContentToEdit: useImageFromContentToEdit,
              useImageFromContentToEditToggle: useImageFromContentToEditToggle,
            ),

            SizedBox(height: 20),

            Text(
              'Defina uma capa de listagem:',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),

            SizedBox(height: 10),

            LongCoverUpload(
              image: (Uint8List newImage) {
                longImage = newImage;
              },
              rgbControllers: {
                'r': _rRGBController,
                'g': _gRGBController,
                'b': _bRGBController,
              },
              mainCover: image,
              useMainCover: useMainCover,
              useMainCoverToggle: useMainCoverToggle,
              title: title,
              deleteImage: deleteLongCover,
              rgb: {'r': rRGB, 'g': gRGB, 'b': bRGB},
              useLongImageFromContentToEdit: useLongImageFromContentToEdit,
              useLongImageFromContentToEditToggle:
                  useLongImageFromContentToEditToggle,
              contentToEdit: contentToEdit,
            ),

            SizedBox(height: 20),
            //Botão de criação
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  alignment: MainAxisAlignment.center,
                  isSelected: false,
                  height: 40,
                  isLoading: isLoadingButton,
                  loadingSize: 0.5,
                  loadingColor: Colors.white,
                  width: 120,
                  color: DashboardTheme.blue,
                  splashColor: const Color.fromARGB(57, 255, 255, 255),
                  onHover: DashboardTheme.blue,
                  text: contentToEdit != null ? 'Atualizar' : 'Criar',
                  fontSize: 15,
                  borderRadius: 10,
                  textColor: Colors.white,
                  onTap: () async {
                    if (isLoadingButton) return;
                    setState(() {
                      isLoadingButton = true;
                    });
                    final snackBarShow = ref.read(snackBarProvider.notifier);

                    //Se não tiver título
                    if (_titleController.text.trim().isEmpty) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Insira um título',
                          error: true,
                        ),
                      );
                      return;
                    }

                    //Se não tiver descrição
                    if (_descriptionController.text.trim().isEmpty) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Insira uma descrição',
                          error: true,
                        ),
                      );
                      return;
                    }

                    //Se a descrição for menor que 40 caracteres
                    if (_descriptionController.text.trim().length < 40) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Sua descrição é menor que 40 caracteres',
                          error: true,
                        ),
                      );
                      return;
                    }

                    //Se não tiver tag
                    if (tagsList.isEmpty) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Defina uma categoria',
                          error: true,
                        ),
                      );
                      return;
                    }

                    if (mainTag == null) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Defina uma categoria principal',
                          error: true,
                        ),
                      );
                      return;
                    }

                    //Se não tiver imagem
                    if ((image == null && contentToEdit == null) ||
                        (image == null &&
                            (contentToEdit != null &&
                                !useImageFromContentToEdit))) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Insira uma imagem de capa',
                          error: true,
                        ),
                      );
                      return;
                    }

                    if (!useMainCover &&
                        longImage == null &&
                        ((contentToEdit == null) ||
                            ((contentToEdit != null &&
                                !useLongImageFromContentToEdit)))) {
                      setState(() {
                        isLoadingButton = false;
                      });
                      snackBarShow.showMessage(
                        SnackBarContent(
                          message: 'Defina uma imagem de capa de listagem',
                          error: true,
                        ),
                      );
                      return;
                    }

                    List<Map<String, String>> tagsIdsList = [];
                    for (var tag in tagsList) {
                      tagsIdsList.add({'id': tag.id!, 'title': tag.title!});
                    }

                    //EDIÇÃO DE CONTENT
                    if (contentToEdit != null) {
                      //RESOLVENDO IMAGENS
                      String? imageUrl;
                      String? miniImageUrl;
                      String? imageLongUrl;
                      if (!useImageFromContentToEdit ||
                          !useLongImageFromContentToEdit) {
                        String? imageBase64;
                        String? longerImage;
                        if (!useImageFromContentToEdit) {
                          imageBase64 = base64Encode(image!);
                        }

                        final isLongImageNew =
                            !useMainCover && !useLongImageFromContentToEdit;

                        if (isLongImageNew) {
                          longerImage = base64Encode(longImage!);
                        }

                        try {
                          final result = await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('uploadImageV3').call({
                            'type': 'contentCover',
                            'imageBase64': imageBase64,
                            'contentId': contentToEdit!.id,
                            'longerCover': longerImage,
                          });
                          final newData = Map<String, dynamic>.from(
                            result.data,
                          );
                          imageUrl = newData['url'];
                          miniImageUrl = newData['miniUrl'];
                          imageLongUrl = newData['longerCoverUrl'];
                        } catch (e) {
                          ref
                              .read(snackBarProvider.notifier)
                              .showMessage(
                                SnackBarContent(
                                  message:
                                      'Ocorreu um erro no upload das imagens | Tente novamente',
                                  error: true,
                                ),
                              );
                          setState(() {
                            isLoadingButton = false;
                          });
                          return;
                        }
                      }

                      try {
                        ContentModel content = ContentModel(
                          title: _titleController.text.trim(),
                          titleSearch: NormalizeString.normalizeString(
                            _titleController.text.trim(),
                          ),
                          cover: imageUrl ?? contentToEdit!.cover,
                          coverMini: miniImageUrl ?? contentToEdit!.coverMini,
                          coverLong: imageLongUrl ?? contentToEdit!.coverLong,
                          description: _descriptionController.text.trim(),
                          tags: tagsIdsList,
                          mainTag: {
                            'id': mainTag!.id!,
                            'title': mainTag!.title!,
                          },
                          rgbColor: {'r': rRGB, 'g': gRGB, 'b': bRGB},
                        );
                        await ContentRepository().update(
                          contentToEdit!.id!,
                          content,
                        );
                      } catch (_) {
                        try {
                          await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('deleteUserFile').call({
                            'fileUrl': imageLongUrl,
                          });
                          await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('deleteUserFile').call({
                            'fileUrl': imageUrl,
                          });
                          await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('deleteUserFile').call({
                            'fileUrl': miniImageUrl,
                          });
                        } catch (_) {}
                        ref
                            .read(snackBarProvider.notifier)
                            .showMessage(
                              SnackBarContent(
                                message:
                                    'Erro na atualização do conteúdo | Tente novamente',
                                error: true,
                              ),
                            );
                        setState(() {
                          isLoadingButton = false;
                        });
                        return;
                      }

                      try {
                        if (imageUrl != null) {
                          await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('deleteUserFile').call({
                            'fileUrl': contentToEdit!.cover,
                          });
                        }
                        if (miniImageUrl != null) {
                          await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('deleteUserFile').call({
                            'fileUrl': contentToEdit!.coverMini,
                          });
                        }
                        if (imageLongUrl != null) {
                          await FirebaseFunctions.instanceFor(
                            region: 'southamerica-east1',
                          ).httpsCallable('deleteUserFile').call({
                            'fileUrl': contentToEdit!.coverLong,
                          });
                        }
                      } catch (_) {}
                      setState(() {
                        isLoadingButton = false;
                      });
                      context.go('/dashboard/obras');
                      if (mounted) {
                        return;
                      }
                    }

                    //CRIAÇÃO DE CONTENT
                    ContentRepository contentR = ContentRepository();
                    final contentId = Uuid().v4();

                    final String imageBase64 = base64Encode(image!);
                    String? longerImage;

                    if (!useMainCover) {
                      longerImage = base64Encode(longImage!);
                    }
                    String? imageUrl;
                    String? miniImageUrl;
                    String? imageLongUrl;

                    try {
                      final result = await FirebaseFunctions.instanceFor(
                        region: 'southamerica-east1',
                      ).httpsCallable('uploadImageV3').call({
                        'type': 'contentCover',
                        'imageBase64': imageBase64,
                        'contentId': contentId,
                        'longerCover': useMainCover ? null : longerImage,
                      });
                      final newData = Map<String, dynamic>.from(result.data);
                      imageUrl = newData['url'];
                      miniImageUrl = newData['miniUrl'];
                      imageLongUrl = newData['longerCoverUrl'];
                    } catch (_) {
                      ref
                          .read(snackBarProvider.notifier)
                          .showMessage(
                            SnackBarContent(
                              message:
                                  'Ocorreu um erro no upload da imagem | Tente novamente',
                              error: true,
                            ),
                          );
                      setState(() {
                        isLoadingButton = false;
                      });
                      return;
                    }

                    //Criação de content
                    try {
                      final id = FirebaseAuth.instance.currentUser!.uid;
                      ContentModel content = ContentModel(
                        id: contentId,
                        title: _titleController.text.trim(),
                        titleSearch: NormalizeString.normalizeString(
                          _titleController.text.trim(),
                        ),
                        cover: imageUrl,
                        coverMini: miniImageUrl,
                        coverLong: imageLongUrl,
                        description: _descriptionController.text.trim(),
                        tags: tagsIdsList,
                        mainTag: {'id': mainTag!.id!, 'title': mainTag!.title!},
                        format: contentType,
                        creatorsIds: [id],
                        creationDate: DateTime.now(),
                        adsUnblocked: false,
                        rgbColor: {'r': rRGB, 'g': gRGB, 'b': bRGB},
                        views: 0,
                        score: 0,
                        likes: 0,
                      );
                      await contentR.create(content, contentId);
                    } catch (_) {
                      ref
                          .read(snackBarProvider.notifier)
                          .showMessage(
                            SnackBarContent(
                              message:
                                  'Erro na criação do conteúdo | Tente novamente',
                              error: true,
                            ),
                          );
                      await FirebaseFunctions.instanceFor(
                        region: 'southamerica-east1',
                      ).httpsCallable('deleteUserFile').call({imageUrl});
                      await FirebaseFunctions.instanceFor(
                        region: 'southamerica-east1',
                      ).httpsCallable('deleteUserFile').call({imageLongUrl});
                      return;
                    }

                    setState(() {
                      isLoadingButton = false;
                    });
                    context.go('/dashboard/obras');
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
