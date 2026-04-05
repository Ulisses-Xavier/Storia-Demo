import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/services/auth_service.dart';
import 'package:storia/utilities/utilities.dart';

class Setprofileimage extends ConsumerStatefulWidget {
  final BuildContext rootContext;
  final String name;
  final String email;
  final String password;
  final VoidCallback changePages;
  const Setprofileimage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.changePages,
    required this.rootContext,
  });

  @override
  ConsumerState<Setprofileimage> createState() => _SetprofileimageState();
}

class _SetprofileimageState extends ConsumerState<Setprofileimage> {
  bool isButtonLoading = false;
  bool pickOn = false;
  //IMAGE FILE
  Uint8List? image;

  List<String> strings = [];

  //CHECAR IMAGEM
  Future<Map<String, dynamic>> checkImage(PlatformFile file) async {
    //Tamanho
    final int fileSizeInBytes = file.size;
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    //Tipo por extensão
    final String? extencao = file.extension?.toLowerCase();

    const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

    final bool isValidType =
        extencao != null && allowedExtensions.contains(extencao);

    return {
      'image': file.bytes,
      'fileSize': fileSizeInMB,
      'isValidType': isValidType,
      'extension': extencao,
    };
  }

  //CARREGAR IMAGEM
  Future<void> pickImage() async {
    pickOn = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) {
      pickOn = false;
      return;
    }

    List<Map<String, dynamic>> imagesData = [];
    imagesData.add(await checkImage(result.files.first));

    bool fileSize = imagesData[0]['fileSize'] <= 3;
    bool typeOk = imagesData[0]['isValidType'];

    if (fileSize && typeOk) {
      setState(() {
        image = imagesData[0]['image'];
      });
      pickOn = false;
      return;
    } else if (!typeOk) {
      Warning.showCenterToast(
        widget.rootContext,
        'Tipo de arquivo incompatível',
      );
      pickOn = false;
      return;
    } else {
      Warning.showCenterToast(
        widget.rootContext,
        'Imagem muito grande: Máx - 3MB',
      );
      pickOn = false;
      return;
    }
  }

  @override
  void initState() {
    strings = [widget.name, widget.email];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => widget.changePages(),
                child: Icon(
                  PhosphorIcons.arrowLeft(),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Imagem de perfil:',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => pickImage(),
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: ColorTheme.secondary,
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child:
                            image != null
                                ? ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    150,
                                  ),
                                  child: Image.memory(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Center(
                                  child: Icon(
                                    PhosphorIcons.user(),
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                      ),
                    ),
                    if (image != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyButton(
                                isSelected: false,
                                height: 40,
                                width: 40,
                                borderRadius: 100,
                                color: const Color.fromARGB(60, 255, 255, 255),
                                spaceBetween: 0,
                                splashColor: Colors.transparent,
                                alignment: MainAxisAlignment.center,
                                icon: PhosphorIcons.x(),
                                iconColor: Colors.white,
                                iconSize: 15,
                                onTap:
                                    () => setState(() {
                                      image = null;
                                    }),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                children:
                    strings.map((string) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: ColorTheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  string,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 19,
                                  width: 19,
                                  decoration: BoxDecoration(
                                    color: ColorTheme.blue,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      PhosphorIcons.check(
                                        PhosphorIconsStyle.bold,
                                      ),
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          MyButton(
            isSelected: false,
            color: ColorTheme.blue,
            loadingColor: Colors.white,
            isLoading: isButtonLoading,
            loadingSize: 0.5,
            height: 60,
            borderRadius: 10,
            alignment: MainAxisAlignment.center,
            spaceBetween: 0,
            text: 'Cadastrar +',
            textColor: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            onTap: () async {
              if (isButtonLoading) return;
              setState(() {
                isButtonLoading = true;
              });
              final result = await ref
                  .read(authServiceProvider.notifier)
                  .createUser(
                    widget.name,
                    widget.email,
                    widget.password,
                    image,
                  );
              if (result) {
                setState(() {
                  isButtonLoading = false;
                });
                Warning.showCenterToast(context, 'Login efeituado com sucesso');
                Navigator.pop(context);
              } else {
                setState(() {
                  isButtonLoading = false;
                });
                Warning.showCenterToast(
                  widget.rootContext,
                  'Não foi possível realizar o cadastro\nTente novamente',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
