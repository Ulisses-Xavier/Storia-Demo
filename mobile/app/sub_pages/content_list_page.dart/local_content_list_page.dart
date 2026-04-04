import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/destaques_page/content_lists/content_list.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/no_content.dart';
import 'package:storia/mobile/app/sub_widgets/content_grid.dart';
import 'package:storia/mobile/app/sub_widgets/error_rebuild.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/feed_content_repository.dart';

class LocalContentListPage extends StatefulWidget {
  final String id;
  const LocalContentListPage({super.key, required this.id});

  @override
  State<LocalContentListPage> createState() => _LocalContentListPageState();
}

class _LocalContentListPageState extends State<LocalContentListPage> {
  bool loadMoreLoading = false;
  bool initialized = false;
  late ScrollController scrollController;
  DocumentSnapshot<Object?>? lastDoc;
  List<ContentModel>? data;
  late final String title;
  late final String id;
  late final Future<Map<String, dynamic>> future;

  Future<void> load() async {
    final localList = LocalContentListList.list;
    for (LocalContentListModel list in localList) {
      if (list.id == widget.id) {
        future = list.futureForPage;
        title = list.title;
        id = list.id;
        return;
      }
    }
  }

  //LOAD MORE CONTENT
  Future<void> loadMore() async {
    if (loadMoreLoading) return;
    setState(() {
      loadMoreLoading = true;
    });
    try {
      late Map<String, dynamic> snapshot;
      if (id == 'novidades') {
        snapshot = await FeedContentRepository().getRecents(
          limitToSix: false,
          lastDoc: lastDoc,
        );
      } else {
        snapshot = await FeedContentRepository().getPopulars(
          limitToSix: false,
          lastDoc: lastDoc,
        );
      }

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

  @override
  void initState() {
    load();
    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 500) {
        loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: ColorTheme.blue),
              );
            }

            if (snapshot.hasError) {
              return ErrorRebuild(function: () {});
            }

            if (!initialized) {
              data = snapshot.data!['data'];
              lastDoc = snapshot.data!['lastDoc'];
            }

            if (data == null || data!.isEmpty) {
              return NoContent();
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        PhosphorIcons.arrowLeft(),
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 25),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          ContentGrid(data: data!),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
