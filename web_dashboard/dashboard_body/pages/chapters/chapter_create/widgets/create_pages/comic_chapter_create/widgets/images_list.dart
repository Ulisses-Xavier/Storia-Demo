import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/image_display.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/no_images.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';
import 'package:uuid/uuid.dart';

class ImagesList extends ConsumerStatefulWidget {
  final ValueChanged<List<Uint8List>> listSet;
  final ValueChanged<List<Map<String, dynamic>?>> listSetImagesAndData;
  const ImagesList({
    super.key,
    required this.listSet,
    required this.listSetImagesAndData,
  });

  @override
  ConsumerState<ImagesList> createState() => _ImagesListState();
}

class _ImagesListState extends ConsumerState<ImagesList> {
  bool edit = false;
  List<Map<String, dynamic>> images = [];
  //CHECAR TAMANHO DA IMAGEM EM MB
  Future<Map<String, dynamic>> checkImage(PlatformFile file) async {
    int fileSizeInBytes = file.size; // tamanho em bytes
    double fileSizeInKB = fileSizeInBytes / 1024; // em KB
    double fileSizeInMB = fileSizeInKB / 1024;

    return {'image': file.bytes, 'fileSize': fileSizeInMB, 'name': file.name};
  }

  //CARREGAR IMAGEM
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) {
      return;
    }

    List<Map<String, dynamic>> imagesData = [];
    for (var file in result.files) {
      imagesData.add(await checkImage(file));
    }

    int errorCount = 0;
    for (var image in imagesData) {
      bool fileSize = image['fileSize'] <= 5;
      if (fileSize) {
        String id = Uuid().v4();
        setState(() {
          images.add({
            'image': image['image'],
            'name': image['name'],
            'id': id,
          });
        });
      } else {
        errorCount++;
      }
    }
    if (images.isNotEmpty) {
      List<Uint8List> listOfImages = [];
      for (var map in images) {
        listOfImages.add(map['image']);
      }
      widget.listSet(listOfImages);
      widget.listSetImagesAndData(images);
    }
    if (errorCount > 0) {
      ref
          .read(snackBarProvider.notifier)
          .showMessage(
            SnackBarContent(
              message:
                  'Não foi possível carregar $errorCount images | Verifique nossas regras de upload',
              error: true,
            ),
          );
    }
  }

  //MANIPULAR ORDEM DA IMAGEM
  void upOrder(int order) {
    if (order == 0) return; // não pode subir mais

    setState(() {
      final current = images[order];
      final previous = images[order - 1];

      // swap visual na lista
      images[order] = previous;
      images[order - 1] = current;
    });

    if (images.isNotEmpty) {
      List<Uint8List> listOfImages = [];
      for (var map in images) {
        listOfImages.add(map['image']);
      }
      widget.listSet(listOfImages);
      widget.listSetImagesAndData(images);
    }
  }

  void downOrder(int order) {
    if (order == images.length - 1) {
      return;
    }

    final current = images[order];
    final next = images[order + 1];

    // swap visual na lista
    images[order] = next;
    images[order + 1] = current;

    if (images.isNotEmpty) {
      List<Uint8List> listOfImages = [];
      for (var map in images) {
        listOfImages.add(map['image']);
      }
      widget.listSet(listOfImages);
      widget.listSetImagesAndData(images);
    }
  }

  //DELETAR IMAGEM
  void deleteImage(String id) {
    List<Map<String, dynamic>> list = [];
    for (var image in images) {
      if (image['id'] != id) {
        list.add(image);
      }
    }
    setState(() {
      images = list;
    });

    List<Uint8List> listOfImages = [];
    for (var map in list) {
      listOfImages.add(map['image']);
    }
    widget.listSet(listOfImages);
    widget.listSetImagesAndData(images.isEmpty ? [] : images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suas imagens',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    MyButton(
                      alignment: MainAxisAlignment.center,
                      isSelected: edit,
                      height: 35,
                      width: 35,
                      color: Colors.transparent,
                      splashColor: const Color.fromARGB(57, 255, 255, 255),
                      icon: LucideIcons.logs,
                      border:
                          !edit
                              ? Border.all(
                                color: const Color.fromARGB(255, 42, 42, 42),
                              )
                              : null,
                      iconSize: 13,
                      borderRadius: 10,
                      selectedColor: DashboardTheme.blue,
                      spaceBetween: 0,
                      onTap: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    MyButton(
                      alignment: MainAxisAlignment.center,
                      isSelected: false,
                      height: 35,
                      loadingColor: Colors.white,
                      loadingSize: 0.5,
                      width: 110,
                      color: DashboardTheme.blue,
                      splashColor: const Color.fromARGB(57, 255, 255, 255),
                      onHover: DashboardTheme.blue,
                      rightIcon: LucideIcons.imagePlus,
                      iconSize: 13,
                      text: 'Upload',
                      spaceBetween: 5,
                      fontSize: 13,
                      borderRadius: 7,
                      textColor: Colors.white,
                      onTap: () async {
                        await pickImage();
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            images.isEmpty
                ? NoImages()
                : Expanded(
                  child: ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ImageDisplay(
                        position: index + 1,
                        image: images[index]['image'],
                        imageName: images[index]['name'],
                        edit: edit,
                        id: images[index]['id'],
                        deleteImage: deleteImage,
                        orderUp: upOrder,
                        orderDown: downOrder,
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
