import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/pages/library/library_widgets/no_content_saved.dart';
import 'package:storia/mobile/app/sub_pages/popups/no_authenticated.dart';
import 'package:storia/mobile/app/sub_widgets/content_grid.dart';
import 'package:storia/mobile/app/sub_widgets/error_rebuild.dart';
import 'package:storia/mobile/app/sub_widgets/no_content_found.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/models/user_model/subs/saved_contents.dart';
import 'package:storia/providers/auth_state_provider.dart';
import 'package:storia/repositories/content/content_repository.dart';
import 'package:storia/utilities/utilities.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  String rebuild = '';
  //
  //
  //
  //FOR SEARCH
  List<SavedContentsModel> listForFilters = [];
  late TextEditingController searchController;
  List<SavedContentsModel> searchedItems = [];
  bool isSearching = false;
  bool theresText = false;
  //
  //
  //FUTURE DATA
  late Future<List<ContentModel>?> future;
  bool initialized = false;

  //LOAD DATA
  Future<List<ContentModel>?> load(List<SavedContentsModel> list) async {
    try {
      final List<String> idsList =
          list
              .map((savedOne) => savedOne.contentId)
              .whereType<String>()
              .toList();

      final result = await ContentRepository().getByList(idsList);
      return result;
    } catch (e) {
      return null;
    }
  }

  void rebuilding() {
    setState(() {
      rebuild = '${rebuild}0';
    });
  }

  void setSearching(String text) {
    if (text.isNotEmpty) {
      setState(() {
        isSearching = true;
      });
      final toSearch =
          listForFilters
              .map((item) {
                final bool ok = item.title!.toLowerCase().contains(
                  text.toLowerCase(),
                );
                if (ok) {
                  return item;
                }
              })
              .whereType<SavedContentsModel>()
              .toList();
      setState(() {
        future = load(toSearch);
      });
    }
  }

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(() {
      if (searchController.text.trim().isNotEmpty && !theresText) {
        setState(() {
          theresText = true;
        });
      } else if (searchController.text.trim().isEmpty && theresText) {
        setState(() {
          theresText = false;
        });
      }
      if ((!initialized || isSearching) && searchController.text.isEmpty) {
        setState(() {
          initialized = false;
          isSearching = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDocumentProvider);
    final savedContents = ref.watch(savedContentsProvider);

    if (user.isLoading) {
      return Center(child: CircularProgressIndicator(color: ColorTheme.blue));
    }

    if (user.value == null) {
      return Center(
        child: NoAuthenticated(color: ColorTheme.background, isPopUp: false),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: savedContents.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: NoContentSaved());
          }

          if ((!initialized && !isSearching) || data != listForFilters) {
            listForFilters = data;
            future = load(data);
            initialized = true;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📑Biblioteca',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.value != null)
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: ColorTheme.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image:
                                user.value!.image != null
                                    ? DecorationImage(
                                      image: NetworkImage(user.value!.image!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      height: 50,
                      backgroundColor: ColorTheme.secondary,
                      hintColor: const Color.fromARGB(118, 255, 255, 255),
                      tipText: 'Pesquisar...',
                      textColor: Colors.white,
                      controller: searchController,
                      textInputAction: TextInputAction.done,
                      function: setSearching,
                      borderRadius: 10,
                      cursorColor: ColorTheme.blue,
                      distanceBetweenButtons: 4,
                      maxLines: 1,
                      eraseButton:
                          theresText
                              ? MyButton(
                                height: 40,
                                width: 40,
                                isSelected: false,
                                color: const Color.fromARGB(50, 42, 42, 42),
                                borderRadius: 10,
                                alignment: MainAxisAlignment.center,
                                icon: PhosphorIcons.x(),
                                iconColor: Colors.white,
                                iconSize: 16,
                                spaceBetween: 0,
                                onHover: const Color.fromARGB(255, 55, 55, 55),
                                splashColor: const Color.fromARGB(
                                  22,
                                  255,
                                  255,
                                  255,
                                ),
                                onTap: () {
                                  setState(() {
                                    searchController.clear();
                                  });
                                },
                              )
                              : null,
                      rightButton: MyButton(
                        height: 40,
                        width: 40,
                        isSelected: false,
                        color: const Color.fromARGB(50, 42, 42, 42),
                        borderRadius: 10,
                        alignment: MainAxisAlignment.center,
                        icon: PhosphorIcons.magnifyingGlass(),
                        iconColor: Colors.white,
                        iconSize: 16,
                        spaceBetween: 0,
                        onHover: const Color.fromARGB(255, 55, 55, 55),
                        splashColor: const Color.fromARGB(22, 255, 255, 255),
                        onTap: () {
                          setSearching(searchController.text.trim());
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  MyButton(
                    height: 50,
                    width: 50,
                    isSelected: false,
                    color: ColorTheme.secondary,
                    borderRadius: 10,
                    alignment: MainAxisAlignment.center,
                    icon: PhosphorIcons.funnel(),
                    iconColor: Colors.white,
                    iconSize: 20,
                    spaceBetween: 0,
                    onHover: const Color.fromARGB(255, 55, 55, 55),
                    splashColor: const Color.fromARGB(22, 255, 255, 255),
                    onTap: () {
                      //widget.offSearching(true);
                      //controller.clear();
                    },
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorTheme.blue,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: ErrorRebuild(function: rebuilding));
                    }

                    final data = snapshot.data;

                    if (data == null || data.isEmpty) {
                      return Center(child: NoContentFound());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [SizedBox(height: 15), ContentGrid(data: data)],
                    );
                  },
                ),
              ),
            ],
          );
        },
        error:
            (_, _) => Container(height: 10, width: 10, color: Colors.lightBlue),
        loading:
            () => Center(
              child: CircularProgressIndicator(color: ColorTheme.blue),
            ),
      ),
    );
  }
}
