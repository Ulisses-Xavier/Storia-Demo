import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/no_images.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class BannerImageUpload extends StatefulWidget {
  final Uint8List? image;
  final ValueChanged<Uint8List> setImage;
  final int? a;
  final int? r;
  final int? g;
  final int? b;
  final String? title;
  final String? description;
  final VoidCallback deleteImage;
  final List<Map<String, dynamic>> tags;
  const BannerImageUpload({
    super.key,
    required this.image,
    required this.setImage,
    required this.deleteImage,
    required this.a,
    required this.r,
    required this.tags,
    required this.g,
    required this.b,
    required this.title,
    required this.description,
  });

  @override
  State<BannerImageUpload> createState() => _BannerImageUploadState();
}

class _BannerImageUploadState extends State<BannerImageUpload> {
  //Tamanho da imagem menor que 1MB
  Map<String, dynamic> sizeCheck(PlatformFile file) {
    int fileSizeInBytes = file.size; // tamanho em bytes
    double fileSizeInKB = fileSizeInBytes / 1024; // em KB
    double fileSizeInMB = fileSizeInKB / 1024;
    return {'ok': fileSizeInMB <= 3, 'size': fileSizeInKB};
  }

  //Dimensões da imagem : 960x1440
  Future<Map<String, dynamic>> dimensionsCheck(PlatformFile file) async {
    final codec = await instantiateImageCodec(file.bytes!);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    return {
      'ok': image.width <= 1920 && image.height <= 2880,
      'width': image.width,
      'height': image.height,
    };
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      PlatformFile pickedFile = result.files.first;

      Map<String, dynamic> size = sizeCheck(pickedFile);

      //Se a imagem for muito grande
      if (!size['ok']) {
        return;
      }

      Map<String, dynamic> dimensions = await dimensionsCheck(pickedFile);

      //Se as dimensões da imagem forem muito grandes
      if (!dimensions['ok']) {
        return;
      }

      //Se tudo estiver ok, imagem carregada
      setState(() {
        widget.setImage(result.files.first.bytes!);
      });
      return;
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          pickImage();
        },
        child: Container(
          width: 292,
          decoration: BoxDecoration(
            color: DashboardTheme.secondary,
            borderRadius: BorderRadius.circular(10),
            border:
                widget.image != null
                    ? null
                    : Border.all(color: Color.fromARGB(255, 42, 42, 42)),
            image:
                widget.image != null
                    ? DecorationImage(
                      image: MemoryImage(widget.image!),
                      fit: BoxFit.cover,
                    )
                    : null,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(30, 5, 5, 5),
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset.fromDirection(1, 2),
              ),
            ],
          ),
          child:
              widget.image == null
                  ? NoImages(
                    color: Color.fromARGB(255, 46, 46, 46),
                    padding: 75,
                  )
                  : Stack(
                    children: [
                      //----GRADIENTE----\\
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 292,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(
                                      widget.a ?? 255,
                                      widget.r ?? 000,
                                      widget.g ?? 000,
                                      widget.b ?? 000,
                                    ),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //----TÍTULO-E-DESCRIÇÃO----\\
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.title ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                              ),
                              child: Text(
                                widget.description ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 7,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            if (widget.tags.isNotEmpty)
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                alignment: WrapAlignment.center,
                                children:
                                    widget.tags.map((tag) {
                                      return IntrinsicWidth(
                                        child: Container(
                                          height: 17,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              tag['a'],
                                              tag['r'],
                                              tag['g'],
                                              tag['b'],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3,
                                              ),
                                              child: Text(
                                                tag['title'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                          ],
                        ),
                      ),

                      //----BOTÃO DE DELETEiMAGE()----\\
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyButton(
                                  isSelected: false,
                                  spaceBetween: 0,
                                  icon: LucideIcons.x,
                                  iconColor: Colors.white,
                                  color: const Color.fromARGB(
                                    70,
                                    255,
                                    255,
                                    255,
                                  ),
                                  height: 30,
                                  width: 30,
                                  alignment: MainAxisAlignment.center,
                                  borderRadius: 100,
                                  onHover: const Color.fromARGB(
                                    70,
                                    255,
                                    255,
                                    255,
                                  ),
                                  onTap: () {
                                    widget.deleteImage();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
