import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/content_display.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/cover_set.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/images_list.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/images_preview.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/tips_balloons.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ComicChapterCreate extends StatefulWidget {
  final ContentModel content;
  const ComicChapterCreate({super.key, required this.content});

  @override
  State<ComicChapterCreate> createState() => _ComicChapterCreateState();
}

class _ComicChapterCreateState extends State<ComicChapterCreate> {
  List<Uint8List> images = [];
  List<Map<String, dynamic>?> imagesAndData = [];

  void listSet(List<Uint8List> list) {
    setState(() {
      images = list;
    });
  }

  void listSetOfImagesAndData(List<Map<String, dynamic>?> list) {
    imagesAndData = list;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                      border: Border.all(
                        color: Color.fromARGB(255, 42, 42, 42),
                      ),
                      splashColor: const Color.fromARGB(57, 255, 255, 255),
                      onHover: DashboardTheme.blue,
                      icon: LucideIcons.arrowLeft100,
                      iconSize: 15,
                      spaceBetween: 0,
                      onTap: () async {
                        context.go('/dashboard/capitulos/publicados');
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
                  loadingColor: Colors.white,
                  width: 120,
                  color: DashboardTheme.blue,
                  splashColor: const Color.fromARGB(57, 255, 255, 255),
                  onHover: DashboardTheme.blue,
                  text: 'Continuar',
                  fontSize: 15,
                  borderRadius: 10,
                  textColor: Colors.white,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Lista de imagens
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      //UPLOAD E LISTAGEM DE IMAGENS
                      ImagesList(
                        listSet: listSet,
                        listSetImagesAndData: listSetOfImagesAndData,
                      ),
                      SizedBox(height: 5),
                      //
                      //RECOMENDAÇÕES E LIMITES
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(40, 56, 92, 182),
                          border: Border.all(
                            color: Color.fromARGB(40, 127, 163, 255),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      color: DashboardTheme.blue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'Recomendações e Limites:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              TipsBalloons(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                //
                //
                //PREVIEW
                Expanded(flex: 1, child: ImagesPreview(images: images)),
              ],
            ),

            //COVER UPLOAD/OPTIONS
            SizedBox(height: 20),
            CoverSet(contentId: widget.content.id!),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
