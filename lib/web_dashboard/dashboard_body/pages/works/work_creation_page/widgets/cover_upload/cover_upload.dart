import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/work_creation_page/widgets/cover_upload/side_widgets.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class CoverUpload extends ConsumerStatefulWidget {
  final ValueChanged<Uint8List> image;
  final VoidCallback deleteImage;
  final ContentModel? contentToEdit;
  final bool useImageFromContentToEdit;
  final VoidCallback useImageFromContentToEditToggle;
  const CoverUpload({
    super.key,
    required this.image,
    required this.deleteImage,
    this.contentToEdit,
    required this.useImageFromContentToEdit,
    required this.useImageFromContentToEditToggle,
  });

  @override
  ConsumerState<CoverUpload> createState() => _CoverUploadState();
}

class _CoverUploadState extends ConsumerState<CoverUpload> {
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
      widget.image(result.files.first.bytes!);
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
            height: 375, //450
            width: 250,
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(15),
              border:
                  imageBytes == null
                      ? Border.all(color: const Color.fromARGB(255, 42, 42, 42))
                      : null,
              image:
                  imageBytes != null ||
                          (widget.useImageFromContentToEdit &&
                              widget.contentToEdit != null)
                      ? DecorationImage(
                        image:
                            (widget.useImageFromContentToEdit &&
                                    widget.contentToEdit != null)
                                ? NetworkImage(widget.contentToEdit!.cover!)
                                : MemoryImage(imageBytes!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Botão Inicial
                if ((imageBytes == null &&
                        (!widget.useImageFromContentToEdit &&
                            widget.contentToEdit != null)) ||
                    (imageBytes == null && widget.contentToEdit == null))
                  MyButton(
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

                //Depois de imagem exibida
                if (((imageBytes != null &&
                            (!widget.useImageFromContentToEdit &&
                                widget.contentToEdit != null)) &&
                        isHover == true) ||
                    ((imageBytes != null && (widget.contentToEdit == null)) &&
                        isHover == true))
                  Expanded(
                    child: Container(
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
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SideWidgets(
            image: imageBytes,
            useImageFromContentToEdit: widget.useImageFromContentToEdit,
            useImageFromContentToEditToggle:
                widget.useImageFromContentToEditToggle,
            contentToEdit: widget.contentToEdit,
          ),
        ),
      ],
    );
  }
}
