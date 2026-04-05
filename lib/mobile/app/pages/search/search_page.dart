import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/no_content.dart';
import 'package:storia/mobile/app/sub_widgets/content_grid.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/models/search_model.dart';
import 'package:storia/repositories/content/feed_content_repository.dart';
import 'package:storia/repositories/search_repository.dart';
import 'package:storia/utilities/utilities.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchController;
  bool isSearching = false;
  bool theresText = false;
  bool loading = false;
  bool mostSearchedLoading = true;

  //Search
  List<ContentModel> data = [];
  DocumentSnapshot<Object?>? lastDoc;
  List<SearchModel> mostSearched = [];

  Future<void> loadMostSearched() async {
    try {
      final query = await SearchRepository().getMostSearched();
      setState(() {
        mostSearched = query;
        mostSearchedLoading = false;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    searchController = TextEditingController();
    loadMostSearched();
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
    });
    super.initState();
  }

  void setSearching(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        isSearching = true;
        loading = true;
      });

      final query = await FeedContentRepository().getBySearch2(
        term: text.toLowerCase(),
      );

      final newData = query['data'];
      final newLastDoc = query['lastDoc'];

      if (newData != null && newData.isNotEmpty) {
        setState(() {
          data = newData;
          lastDoc = newLastDoc;
          loading = false;
        });
      } else {
        setState(() {
          data = [];
          lastDoc = null;
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
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
                      theresText || isSearching
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
                                isSearching = false;
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
                      final text = searchController.text.trim();
                      setSearching(text);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (loading)
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Transform.scale(
                  scale: 0.5,
                  child: Center(
                    child: CircularProgressIndicator(color: ColorTheme.blue),
                  ),
                ),
              ),
            ),
          if (data.isNotEmpty && !loading && isSearching)
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Column(
                    children: [ContentGrid(data: data, isAppSearch: true)],
                  ),
                ),
              ),
            )
          else if (isSearching && !loading)
            NoContent(),

          if (!isSearching && mostSearchedLoading)
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Transform.scale(
                  scale: 0.5,
                  child: Center(
                    child: CircularProgressIndicator(color: ColorTheme.blue),
                  ),
                ),
              ),
            ),
          if (!isSearching && mostSearched.isNotEmpty && !mostSearchedLoading)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Mais buscados',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorTheme.secondary,
                      ),
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.builder(
                          itemCount: mostSearched.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            final item = mostSearched[index];
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                    index == 0
                                        ? BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )
                                        : index == mostSearched.length - 1
                                        ? BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        )
                                        : null,
                                onTap: () {},
                                child: Ink(
                                  height: 90,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: item.coverUrl!,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: Colors.grey.shade800,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 7),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: 200,
                                              ),
                                              child: Text(
                                                item.title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 23,
                                              decoration: BoxDecoration(
                                                color: ColorTheme.blue,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 7.0,
                                                    ),
                                                child: Center(
                                                  child: Text(
                                                    item.mainTag!,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Poppins',
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
