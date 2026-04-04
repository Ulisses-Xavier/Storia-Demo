import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/save_cover_popup.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/tips_balloons.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class CoverSet extends ConsumerStatefulWidget {
  final String contentId;
  const CoverSet({super.key, required this.contentId});

  @override
  ConsumerState<CoverSet> createState() => _CoverSetState();
}

class _CoverSetState extends ConsumerState<CoverSet> {
  bool hover = false;
  //COVER FILE
  Uint8List? cover;

  //CHECAR TAMANHO DA IMAGEM EM MB
  Future<Map<String, dynamic>> checkImage(PlatformFile file) async {
    int fileSizeInBytes = file.size; // tamanho em bytes
    double fileSizeInKB = fileSizeInBytes / 1024; // em KB
    double fileSizeInMB = fileSizeInKB / 1024;

    return {'image': file.bytes, 'fileSize': fileSizeInMB};
  }

  //CARREGAR IMAGEM
  Future<Uint8List?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) {
      return null;
    }

    List<Map<String, dynamic>> imagesData = [];
    imagesData.add(await checkImage(result.files.first));

    bool fileSize = imagesData[0]['fileSize'] <= 1;
    if (fileSize) {
      setState(() {
        cover = imagesData[0]['image'];
      });
      return imagesData[0]['image'];
    } else {
      ref
          .read(snackBarProvider.notifier)
          .showMessage(
            SnackBarContent(
              message:
                  'Não foi possível carregar a imagem | Verifique nossas regras de upload',
              error: true,
            ),
          );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Capa do capítulo:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: DashboardTheme.secondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color.fromARGB(255, 42, 42, 42)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(30, 5, 5, 5),
                blurRadius: 5,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) {
                    setState(() {
                      hover = true;
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      hover = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final result = await pickImage();
                      if (result != null) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return SaveCover(image: result);
                          },
                        );
                      }
                    },
                    child: Container(
                      height: double.infinity,
                      width: 144,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(40, 56, 92, 182),
                        border: Border.all(
                          color: Color.fromARGB(40, 127, 163, 255),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          cover != null
                              ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10,
                                    ),
                                    child: Image.memory(
                                      cover!,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                                  ),
                                  if (hover && cover != null)
                                    Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          149,
                                          1,
                                          22,
                                          55,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 15,
                                            ),
                                            child: Icon(
                                              LucideIcons.imagePlus,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),

                                          //Main Text
                                          Text(
                                            'Carregar nova\nimagem',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Icon(
                                      LucideIcons.imagePlus,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),

                                  //Main Text
                                  Text(
                                    'Carregar imagem',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //
        //RECOMENDAÇÕES
        SizedBox(height: 5),
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(40, 56, 92, 182),
            border: Border.all(color: Color.fromARGB(40, 127, 163, 255)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [SizedBox(width: 5), TipsBalloons(isCover: true)],
          ),
        ),
      ],
    );
  }
}
