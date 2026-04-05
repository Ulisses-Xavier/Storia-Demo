import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/feed_content_repository.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class SelectRoutePopup extends StatefulWidget {
  const SelectRoutePopup({super.key});

  @override
  State<SelectRoutePopup> createState() => _SelectRoutePopupState();
}

class _SelectRoutePopupState extends State<SelectRoutePopup> {
  late Future<Map<String, dynamic>> future;
  late TextEditingController searchController;
  late ScrollController scrollController;
  bool isInitialized = false;
  bool loadMoreLoading = false;
  DocumentSnapshot<Object?>? lastDoc;
  List<ContentModel>? data;
  bool searching = false;

  @override
  void initState() {
    super.initState();
    future = FeedContentRepository().get();
    scrollController = ScrollController();
    searchController = TextEditingController();

    //scrollController.addListener(() {
    //  if (scrollController.position.pixels >
    //      scrollController.position.maxScrollExtent - 500) {
    //    loadMore();
    //  }
    //});
  }

  Future<void> loadMore() async {
    if (loadMoreLoading) return;
    setState(() {
      loadMoreLoading = true;
    });
    try {
      late Map<String, dynamic> snapshot;
      snapshot = await FeedContentRepository().get(lastDoc: lastDoc);

      final newData = snapshot['data'];
      final newLastDoc = snapshot['newLastDoc'];
      if (newData.isNotEmpty) {
        setState(() {
          data!.addAll(newData);
          lastDoc = newLastDoc;
        });
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        loadMoreLoading = false;
      });
    }
  }

  Future<void> search(String term) async {
    try {
      final snapshot = await FeedContentRepository().getBySearch(
        term: NormalizeString.normalizeString(term),
      );

      setState(() {
        data = snapshot;
        searching = true;
      });
    } catch (e) {
      debugPrint('Aqui, baby: ${e.toString()}');
    }
  }

  void offSearching(bool off) {
    setState(() {
      isInitialized = false;
      searching = false;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 400,
        decoration: BoxDecoration(
          color: DashboardTheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecione uma obra para a rota:',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: MyTextField(
                        height: 45,
                        backgroundColor: DashboardTheme.secondary,
                        borderRadius: 10,
                        controller: searchController,
                        border: Border.all(
                          color: const Color.fromARGB(255, 42, 42, 42),
                        ),
                        tipText: 'Pesquisar...',
                        textColor: Colors.white,
                        maxLines: 1,
                        fontSize: 13,
                        distanceBetweenButtons: 3,
                        eraseButton:
                            searching
                                ? MyButton(
                                  height: 30,
                                  width: 30,
                                  isSelected: false,
                                  color: const Color.fromARGB(50, 42, 42, 42),
                                  borderRadius: 10,
                                  alignment: MainAxisAlignment.center,
                                  icon: LucideIcons.x,
                                  iconColor: Colors.white,
                                  iconSize: 12,
                                  spaceBetween: 0,
                                  onHover: const Color.fromARGB(
                                    255,
                                    55,
                                    55,
                                    55,
                                  ),
                                  splashColor: const Color.fromARGB(
                                    22,
                                    255,
                                    255,
                                    255,
                                  ),
                                  onTap: () {
                                    offSearching(false);
                                  },
                                )
                                : null,
                        rightButton: MyButton(
                          height: 30,
                          width: 30,
                          isSelected: false,
                          color: const Color.fromARGB(50, 42, 42, 42),
                          borderRadius: 10,
                          alignment: MainAxisAlignment.center,
                          icon: LucideIcons.search100,
                          iconColor: Colors.white,
                          iconSize: 12,
                          spaceBetween: 0,
                          onHover: const Color.fromARGB(255, 55, 55, 55),
                          splashColor: const Color.fromARGB(22, 255, 255, 255),
                          onTap: () async {
                            try {
                              await search(searchController.text.trim());
                            } catch (e) {
                              debugPrint('ERRROR: ${e.toString()}');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: DashboardTheme.blue,
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  'ERRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  'NO DATA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (!isInitialized) {
                            data = snapshot.data!['data'];
                            lastDoc = snapshot.data!['lastDoc'];
                            isInitialized = true;
                          }

                          if (data == null || data!.isEmpty) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  'NO DATA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, //Número por linha
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 1 / 1.6,
                                ),
                            itemBuilder: (context, index) {
                              final content = data![index];

                              return ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(6),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    splashColor: DashboardTheme.blue.withAlpha(
                                      20,
                                    ),
                                    onDoubleTap: () {
                                      Navigator.pop(
                                        context,
                                        '/content/${content.id}',
                                      );
                                    },
                                    child: Ink.image(
                                      image: NetworkImage(content.coverMini!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
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
    );
  }
}
