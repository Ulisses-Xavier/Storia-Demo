import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/widgets/long_cover_upload/long_cover_side_widgets.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class LongCoverUpload extends ConsumerStatefulWidget {
  final ValueChanged<Uint8List> image;
  final VoidCallback deleteImage;
  final bool useMainCover;
  final VoidCallback useMainCoverToggle;
  final Map<String, TextEditingController> rgbControllers;
  final String? title;
  final Uint8List? mainCover;
  final Map<String, int> rgb;
  final ContentModel? contentToEdit;
  final bool useLongImageFromContentToEdit;
  final VoidCallback useLongImageFromContentToEditToggle;
  const LongCoverUpload({
    super.key,
    required this.image,
    this.mainCover,
    this.title,
    this.contentToEdit,
    required this.useLongImageFromContentToEdit,
    required this.useLongImageFromContentToEditToggle,
    required this.rgb,
    required this.rgbControllers,
    required this.useMainCoverToggle,
    required this.deleteImage,
    required this.useMainCover,
  });

  @override
  ConsumerState<LongCoverUpload> createState() => _LongCoverUploadState();
}

class _LongCoverUploadState extends ConsumerState<LongCoverUpload> {
  Uint8List? imageBytes;
  bool isHover = false;

  //Tamanho da imagem menor que 1MB
  Map<String, dynamic> sizeCheck(PlatformFile file) {
    int fileSizeInBytes = file.size; // tamanho em bytes
    double fileSizeInKB = fileSizeInBytes / 1024; // em KB
    double fileSizeInMB = fileSizeInKB / 1024;
    return {'ok': fileSizeInMB <= 1, 'size': fileSizeInKB};
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

  Future<Map<String, dynamic>?> pickImage() async {
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
        return {
          'ok': false,
          'message': 'Tamanho da imagem muito grande: (${size['size']}MB)',
        };
      }

      Map<String, dynamic> dimensions = await dimensionsCheck(pickedFile);

      //Se as dimensões da imagem forem muito grandes
      if (!dimensions['ok']) {
        return {
          'ok': false,
          'message':
              dimensions['height'] > 1440
                  ? 'Comprimento da imagem muito grande (altura: ${dimensions['height']})'
                  : 'Largura da imagem muito grande (${dimensions['width']})',
        };
      }

      //Se tudo estiver ok, imagem carregada
      setState(() {
        imageBytes = result.files.first.bytes;
      });
      return {'ok': true, 'message': 'Imagem carregada com sucesso'};
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MouseRegion(
          onHover: ((_) {
            setState(() {
              isHover = true;
            });
          }),
          onExit: ((_) {
            setState(() {
              isHover = false;
            });
          }),
          child: Container(
            height: 450,
            width: 250,
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(15),
              border:
                  (widget.mainCover == null && imageBytes == null) ||
                          ((widget.mainCover == null && widget.useMainCover) ||
                              (imageBytes == null && !widget.useMainCover))
                      ? Border.all(color: const Color.fromARGB(255, 42, 42, 42))
                      : null,
              image: //SE CONTENTtoEDIT EXISTIR E SE FOR PRA USAR A COVER DELE
                  (widget.contentToEdit != null &&
                          widget.useLongImageFromContentToEdit)
                      ? DecorationImage(
                        image: NetworkImage(
                          widget.contentToEdit!.coverLong ??
                              widget.contentToEdit!.cover!,
                        ),
                        fit: BoxFit.cover,
                      )
                      :
                      //SE HÁ MAIN COVER E SE É PRA USAR MAIN COVER
                      (widget.mainCover != null && widget.useMainCover == true)
                      ? DecorationImage(
                        image: MemoryImage(widget.mainCover!),
                        fit: BoxFit.cover,
                      )
                      :
                      //SE A LONGCOVER NÃO É NULL E SE NÃO É PRA USAR MAIN COVER
                      (imageBytes != null)
                      ? DecorationImage(
                        image: MemoryImage(imageBytes!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child: SizedBox(
              height: 450,
              width: 250,
              child: Stack(
                children: [
                  if ((imageBytes != null ||
                      (widget.mainCover != null && widget.useMainCover) ||
                      (widget.contentToEdit != null &&
                          widget.useLongImageFromContentToEdit)))
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(
                                    255,
                                    widget.rgb['r']!,
                                    widget.rgb['g']!,
                                    widget.rgb['b']!,
                                  ),
                                  Color.fromARGB(
                                    220,
                                    widget.rgb['r']!,
                                    widget.rgb['g']!,
                                    widget.rgb['b']!,
                                  ),
                                  Colors.transparent,
                                ],
                                begin: AlignmentGeometry.bottomCenter,
                                end: AlignmentGeometry.topCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    widget.title == null
                                        ? 'Sem título'
                                        : widget.title!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      height: 1.5,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 24,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        90,
                                        255,
                                        255,
                                        255,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '100K',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  //Botão Inicial
                  if (imageBytes == null &&
                      !widget.useMainCover &&
                      ((widget.contentToEdit != null &&
                              !widget.useLongImageFromContentToEdit) ||
                          widget.contentToEdit == null))
                    Center(
                      child: MyButton(
                        alignment: MainAxisAlignment.center,
                        isSelected: false,
                        height: 35,
                        width: 120,
                        color: DashboardTheme.blue,
                        splashColor: const Color.fromARGB(57, 255, 255, 255),
                        icon: LucideIcons.upload,
                        onHover: DashboardTheme.blue,
                        text: 'Upload',
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        borderRadius: 10,
                        textColor: Colors.white,
                        onTap: () async {
                          final result = await pickImage();

                          if (result != null && !result['ok']) {
                            ref
                                .read(snackBarProvider.notifier)
                                .showMessage(
                                  SnackBarContent(
                                    message: result['message'],
                                    error: true,
                                  ),
                                );
                          }

                          if (result!['ok']) {
                            ref
                                .read(snackBarProvider.notifier)
                                .showMessage(
                                  SnackBarContent(
                                    message: result['message'],
                                    error: false,
                                  ),
                                );
                            widget.image(imageBytes!);
                          }
                        },
                      ),
                    ),

                  //Depois de imagem exibida
                  if (imageBytes != null &&
                      isHover == true &&
                      !widget.useMainCover)
                    Container(
                      height: double.infinity,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(220, 28, 28, 28),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Botão de remover
                          MyButton(
                            alignment: MainAxisAlignment.center,
                            isSelected: false,
                            height: 40,
                            width: 140,
                            color: Colors.white,
                            splashColor: const Color.fromARGB(
                              57,
                              255,
                              255,
                              255,
                            ),
                            icon: LucideIcons.x,
                            text: 'Remover',
                            iconColor: Colors.black,
                            onHover: const Color.fromARGB(255, 195, 195, 195),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            borderRadius: 10,
                            textColor: Colors.black,
                            onTap: () {
                              setState(() {
                                imageBytes = null;
                              });
                              widget.deleteImage();
                            },
                          ),

                          SizedBox(height: 7),

                          //Mesmo botão de upload
                          MyButton(
                            alignment: MainAxisAlignment.center,
                            isSelected: false,
                            height: 40,
                            width: 140,
                            color: DashboardTheme.blue,
                            splashColor: const Color.fromARGB(
                              57,
                              255,
                              255,
                              255,
                            ),
                            icon: LucideIcons.upload,
                            onHover: DashboardTheme.blue,
                            fontWeight: FontWeight.w600,
                            text: 'Escolher outra',
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            borderRadius: 10,
                            textColor: Colors.white,
                            onTap: () async {
                              final result = await pickImage();

                              if (!result!['ok']) {
                                ref
                                    .read(snackBarProvider.notifier)
                                    .showMessage(
                                      SnackBarContent(
                                        message: result['message'],
                                        error: !result['ok'],
                                      ),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: LongCoverSideWidgets(
            useMainCoverToggle: widget.useMainCoverToggle,
            useMainCover: widget.useMainCover,
            rgbControllers: widget.rgbControllers,
            useLongImageFromContentToEdit: widget.useLongImageFromContentToEdit,
            useLongImageFromContentToEditToggle:
                widget.useLongImageFromContentToEditToggle,
            contentToEdit: widget.contentToEdit,
          ),
        ),
      ],
    );
  }
}
