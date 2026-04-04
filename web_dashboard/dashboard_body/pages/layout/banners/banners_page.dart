import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/banners_model.dart';
import 'package:storia/repositories/banners_repository.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/widgets/banner_create.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/widgets/banner_display.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/widgets/banner_image_upload.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/layout/banners/widgets/banners_list.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class BannersPage extends StatefulWidget {
  const BannersPage({super.key});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> {
  bool isLoading = false;
  bool createBanner = false;
  bool editing = false;

  BannersModel? chosenBanner;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _aController;
  late final TextEditingController _rController;
  late final TextEditingController _gController;
  late final TextEditingController _bController;
  late final TextEditingController _tagController;
  late final TextEditingController _routerController;

  //TagsControllers
  late final TextEditingController _aTagController;
  late final TextEditingController _rTagController;
  late final TextEditingController _gTagController;
  late final TextEditingController _bTagController;

  String? title;
  String? description;
  int? a;
  int? r;
  int? g;
  int? b;
  String? tagTitle;

  int? aTag;
  int? rTag;
  int? gTag;
  int? bTag;

  Uint8List? image;
  List<Map<String, dynamic>> tags = [];
  String? route;
  List<Map<String, dynamic>> editedBanners = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _aController = TextEditingController();
    _rController = TextEditingController();
    _gController = TextEditingController();
    _bController = TextEditingController();
    _tagController = TextEditingController();
    _routerController = TextEditingController();

    _aTagController = TextEditingController();
    _rTagController = TextEditingController();
    _gTagController = TextEditingController();
    _bTagController = TextEditingController();

    _aController.text = '255';
    _aTagController.text = '255';
    a = 255;
    r = 000;
    g = 000;
    b = 000;

    aTag = 255;
    rTag = 000;
    gTag = 000;
    bTag = 000;

    _titleController.addListener(() {
      setState(() {
        title = _titleController.text;
      });
    });

    _descriptionController.addListener(() {
      setState(() {
        description = _descriptionController.text;
      });
    });

    _aController.addListener(() {
      setState(() {
        a = int.tryParse(_aController.text) ?? 000;
      });
    });

    _rController.addListener(() {
      setState(() {
        r = int.tryParse(_rController.text) ?? 000;
      });
    });

    _gController.addListener(() {
      setState(() {
        g = int.tryParse(_gController.text) ?? 000;
      });
    });

    _bController.addListener(() {
      setState(() {
        b = int.tryParse(_bController.text) ?? 000;
      });
    });

    _tagController.addListener(() {
      setState(() {
        tagTitle = _tagController.text;
      });
    });

    _routerController.addListener(() {
      setState(() {
        route = _routerController.text;
      });
    });

    //TagListeners\\

    _aTagController.addListener(() {
      setState(() {
        aTag = int.tryParse(_aTagController.text) ?? 000;
      });
    });

    _rTagController.addListener(() {
      setState(() {
        rTag = int.tryParse(_rTagController.text) ?? 000;
      });
    });

    _gTagController.addListener(() {
      setState(() {
        gTag = int.tryParse(_gTagController.text) ?? 000;
      });
    });

    _bTagController.addListener(() {
      setState(() {
        bTag = int.tryParse(_bTagController.text) ?? 000;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _aController.dispose();
    _rController.dispose();
    _gController.dispose();
    _bController.dispose();
    _tagController.dispose();
    _aTagController.dispose();
    _rTagController.dispose();
    _gTagController.dispose();
    _bTagController.dispose();
    _routerController.dispose();
    super.dispose();
  }

  void setImage(Uint8List newImage) {
    setState(() {
      image = newImage;
    });
  }

  void deleteImage() {
    setState(() {
      image = null;
    });
  }

  void setTag() {
    final tag = {'title': tagTitle, 'a': aTag, 'r': rTag, 'g': gTag, 'b': bTag};
    setState(() {
      tags.add(tag);
    });
  }

  void createToggle() {
    setState(() {
      createBanner = !createBanner;
    });
  }

  void setChosenBanner(BannersModel banner) {
    setState(() {
      chosenBanner = banner;
    });
  }

  void editingToggle() {
    setState(() {
      editing = !editing;
    });
  }

  void setEditedBanners(List<Map<String, dynamic>> editedOnes) {
    editedBanners = editedOnes;
  }

  void removeTag(String title) {
    setState(() {
      tags.removeWhere((tag) => tag['title'] == title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(30, 5, 5, 5),
                  blurRadius: 5,
                  spreadRadius: 5,
                  offset: Offset.fromDirection(1, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        createBanner ? ' Criar Banner' : '  Seus Banners',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      createBanner
                          ? Row(
                            children: [
                              MyButton(
                                alignment: MainAxisAlignment.center,
                                isSelected: false,
                                height: 35,
                                width: 35,
                                color: Colors.transparent,
                                splashColor: const Color.fromARGB(
                                  57,
                                  255,
                                  255,
                                  255,
                                ),
                                icon: LucideIcons.arrowLeft100,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 42, 42, 42),
                                ),
                                iconSize: 13,
                                borderRadius: 10,
                                selectedColor: DashboardTheme.blue,
                                spaceBetween: 0,
                                onTap: () {
                                  createToggle();
                                },
                              ),
                              SizedBox(width: 10),
                              MyButton(
                                alignment: MainAxisAlignment.center,
                                isSelected: false,
                                height: 35,
                                isLoading: isLoading,
                                loadingColor: Colors.white,
                                loadingSize: 0.5,
                                width: 110,
                                color: DashboardTheme.blue,
                                splashColor: const Color.fromARGB(
                                  57,
                                  255,
                                  255,
                                  255,
                                ),
                                onHover: DashboardTheme.blue,
                                iconSize: 13,
                                text: 'Salvar',
                                spaceBetween: 0,
                                fontSize: 13,
                                borderRadius: 7,
                                textColor: Colors.white,
                                onTap: () async {
                                  if (!isLoading) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bool titleOk = title != null && title != '';
                                    bool imageOk = image != null;
                                    bool routeOk = route != null;

                                    if (titleOk && imageOk && routeOk) {
                                      final banners =
                                          await BannersRepository().getAll();
                                      int bannerOrder = 1;
                                      if (banners != null) {
                                        int biggestOrder = 1;
                                        for (BannersModel banner in banners) {
                                          final order = banner.order;
                                          if (order! > biggestOrder) {
                                            biggestOrder = order;
                                          }
                                        }
                                        bannerOrder = biggestOrder + 1;
                                      }

                                      final String newImage = base64Encode(
                                        image!,
                                      );
                                      final function =
                                          FirebaseFunctions.instanceFor(
                                            region: "southamerica-east1",
                                          ).httpsCallable('createBanner');
                                      await function.call({
                                        'title': title,
                                        'description': description,
                                        'imageBase64': newImage,
                                        'gradientColor': {
                                          'a': a,
                                          'r': r,
                                          'g': g,
                                          'b': b,
                                        },
                                        'tags': tags,
                                        'route': route,
                                        'order': bannerOrder,
                                      });
                                      setState(() {
                                        isLoading = false;
                                      });
                                      createToggle();
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                          : Row(
                            children: [
                              MyButton(
                                alignment: MainAxisAlignment.center,
                                isSelected: editing,
                                height: 35,
                                width: 35,
                                color: Colors.transparent,
                                splashColor: const Color.fromARGB(
                                  57,
                                  255,
                                  255,
                                  255,
                                ),
                                icon: LucideIcons.logs,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 42, 42, 42),
                                ),
                                iconSize: 13,
                                borderRadius: 10,
                                selectedColor: DashboardTheme.blue,
                                spaceBetween: 0,
                                onTap: () {
                                  setState(() {
                                    chosenBanner = null;
                                  });
                                  editingToggle();
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
                                splashColor: const Color.fromARGB(
                                  57,
                                  255,
                                  255,
                                  255,
                                ),
                                onHover: DashboardTheme.blue,
                                rightIcon: editing ? null : LucideIcons.plus,
                                iconSize: editing ? null : 13,
                                text: editing ? 'Salvar' : 'Criar',
                                spaceBetween: editing ? 0 : 5,
                                fontSize: 13,
                                borderRadius: 7,
                                textColor: Colors.white,
                                onTap: () async {
                                  if (editing) {
                                    try {
                                      await FirebaseFunctions.instanceFor(
                                        region: "southamerica-east1",
                                      ).httpsCallable("reorderBanner").call({
                                        'data': editedBanners,
                                      });
                                      editingToggle();
                                    } on FirebaseFunctionsException catch (e) {
                                      debugPrint('AQUIIIII ${e.toString()}');
                                    }
                                  } else {
                                    createToggle();
                                  }
                                },
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                createBanner
                    ? Expanded(
                      child: BannerCreate(
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        aController: _aController,
                        rController: _rController,
                        routerController: _routerController,
                        gController: _gController,
                        bController: _bController,
                        tagController: _tagController,
                        aTagController: _aTagController,
                        rTagController: _rTagController,
                        gTagController: _gTagController,
                        bTagController: _bTagController,
                        aTag: aTag,
                        rTag: rTag,
                        gTag: gTag,
                        bTag: bTag,
                        tagTitle: tagTitle,
                        setTag: setTag,
                        removeTag: removeTag,
                        tags: tags,
                      ),
                    )
                    : Expanded(
                      child: BannersList(
                        setChosenBanner: setChosenBanner,
                        chosenBanner: chosenBanner,
                        editing: editing,
                        editingToggle: editingToggle,
                        setEditedBanners: setEditedBanners,
                      ),
                    ),
              ],
            ),
          ),
        ),
        SizedBox(width: 7),
        Container(
          height: 300 / 1.2,
          width: 300,
          decoration: BoxDecoration(
            color: DashboardTheme.secondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
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
              !createBanner
                  ? BannerDisplay(banner: chosenBanner)
                  : BannerImageUpload(
                    image: image,
                    setImage: setImage,
                    deleteImage: deleteImage,
                    tags: tags,
                    a: a,
                    b: b,
                    r: r,
                    g: g,
                    title: title,
                    description: description,
                  ),
        ),
      ],
    );
  }
}
