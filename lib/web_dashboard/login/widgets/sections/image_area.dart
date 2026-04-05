import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/providers/register_data_provider.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class ImageArea extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const ImageArea({super.key, required this.data});

  @override
  ConsumerState<ImageArea> createState() => _ImageAreaState();
}

class _ImageAreaState extends ConsumerState<ImageArea> {
  //COVER FILE
  Uint8List? image;

  //Loading buttons
  bool isLoadingContinue = false;
  bool isLoadingIgnore = false;

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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) {
      return;
    }

    List<Map<String, dynamic>> imagesData = [];
    imagesData.add(await checkImage(result.files.first));

    bool fileSize = imagesData[0]['fileSize'] <= 3;
    bool typeOk = imagesData[0]['isValidType'];
    final snack = ref.read(snackBarProvider.notifier);

    if (fileSize && typeOk) {
      setState(() {
        image = imagesData[0]['image'];
      });
    } else if (!typeOk) {
      snack.showMessage(
        SnackBarContent(
          message: 'Só aceitamos imagens jpg, jpeg, png, webp',
          error: true,
        ),
      );
      return;
    } else {
      snack.showMessage(
        SnackBarContent(
          message: 'O tamanho máximo suportado é de 3Mb',
          error: true,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Text
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Imagem de perfil',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 20,
              ),
            ),
          ),
          //Image Set
          Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.transparent,
                  border: Border.all(color: DashboardTheme.blue, width: 2),
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      height: 190,
                      width: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: DashboardTheme.background,
                      ),
                      child:
                          image != null
                              ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    100,
                                  ),
                                  child: Image.memory(
                                    image!,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                              : Center(
                                child: Icon(
                                  LucideIcons.imagePlus200,
                                  color: DashboardTheme.blue,
                                  size: 60,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              //
              //
              //
              //
              //NAME
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.data['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 5),

                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 20, 213, 107),
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0),
              Text(
                widget.data['email'],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 6,
                ),
              ),
            ],
          ),
          Column(
            children: [
              MyButton(
                isSelected: false,
                width: 300,
                alignment: MainAxisAlignment.center,
                height: 40,
                color: Colors.transparent,
                onHover: Colors.transparent,
                text: isLoadingIgnore ? null : 'Ignorar por enquanto',
                rightIcon: isLoadingIgnore ? null : LucideIcons.moveRight100,
                iconSize: 30,
                isLoading: isLoadingIgnore,
                loadingColor: Colors.white,
                loadingSize: 0.5,
                fontSize: 12,
                fontFamily: 'Poppins',
                iconColor: Colors.white,
                fontWeight: FontWeight.w200,
                spaceBetween: isLoadingIgnore ? 0 : 5,
                onTap: () async {
                  if (!isLoadingIgnore) {
                    setState(() {
                      isLoadingIgnore = true;
                    });
                    final setData = ref.read(registerDataNotifier.notifier);
                    setData.setData({'name': widget.data['name']});

                    final auth = FirebaseAuth.instance;

                    await auth.createUserWithEmailAndPassword(
                      email: widget.data['email'],
                      password: widget.data['password'],
                    );

                    setState(() {
                      isLoadingIgnore = false;
                    });
                  }
                },
              ),
              SizedBox(height: 5),
              MyButton(
                isSelected: false,
                width: 300,
                alignment: MainAxisAlignment.center,
                height: 40,
                color: DashboardTheme.blue,
                onHover: DashboardTheme.blue,
                borderRadius: 10,
                isLoading: isLoadingContinue,
                loadingColor: Colors.white,
                loadingSize: 0.5,
                text: isLoadingContinue ? null : 'Continuar',
                fontSize: 15,
                fontFamily: 'Poppins',
                spaceBetween: 0,
                onTap: () async {
                  if (!isLoadingContinue) {
                    final setData = ref.read(registerDataNotifier.notifier);
                    setState(() {
                      isLoadingContinue = true;
                    });
                    setData.setData({
                      'name': widget.data['name'],
                      'image': image,
                    });

                    final auth = FirebaseAuth.instance;

                    try {
                      await auth.createUserWithEmailAndPassword(
                        email: widget.data['email'],
                        password: widget.data['password'],
                      );
                    } catch (_) {
                      ref
                          .read(snackBarProvider.notifier)
                          .showMessage(
                            SnackBarContent(
                              message:
                                  'Houve um erro na criação do usuário | tente novamente',
                              error: true,
                            ),
                          );
                    }
                  }
                  setState(() {
                    isLoadingContinue = false;
                  });
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
