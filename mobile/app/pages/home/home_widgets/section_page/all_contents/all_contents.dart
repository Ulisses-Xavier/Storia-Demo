import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/all_contents/all_contents_widgets/order_preference_bottom_sheet.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/no_content.dart';
import 'package:storia/mobile/app/sub_widgets/content_grid.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/feed_content_repository.dart';
import 'package:storia/utilities/utilities.dart';

class AllContents extends ConsumerStatefulWidget {
  const AllContents({super.key});

  @override
  ConsumerState<AllContents> createState() => _AllContentsState();
}

class _AllContentsState extends ConsumerState<AllContents>
    with AutomaticKeepAliveClientMixin {
  //HERE BEGINS
  late ScrollController scrollController;
  bool initialized = false;
  bool loading = true;
  bool loadMoreLoading = false;
  late final Future<Map<String, dynamic>> future;

  //FILTERS
  List<String> tagsIds = [];
  String sortBy = 'popular'; // popular | newChap | newContent

  //Data
  List<ContentModel>? data;
  DocumentSnapshot<Object?>? lastDoc;

  //INITIAL LOAD
  Future<void> loadInitial() async {
    final query = await FeedContentRepository().getByFilters();

    setState(() {
      data = query['data'];
      lastDoc = query['lastDoc'];
      loading = false;
    });
  }

  //INIT STATE
  @override
  void initState() {
    super.initState();
    loadInitial();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 300) {
        loadMore();
      }
    });
  }

  //DISPOSE
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //LOAD MORE CONTENT
  Future<void> loadMore() async {
    if (loadMoreLoading) return;
    loadMoreLoading = true;
    setState(() {});
    try {
      late Map<String, dynamic> snapshot;

      snapshot = await FeedContentRepository().getByFilters(
        tagsIds: tagsIds,
        sortBy: sortBy,
        lastDoc: lastDoc,
      );

      final newLastDoc = snapshot['lastDoc'];
      final newData = snapshot['data'];
      if (newData.isNotEmpty) {
        setState(() {
          lastDoc = newLastDoc;
          data!.addAll(newData);
        });
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        loadMoreLoading = false;
      });
    }
  }

  void setPreferences(bool isOrder) async {
    if (loading) {
      Warning.showCenterToast(context, 'Operação em andamento');
    }

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (rootContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // limite
          ),
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                AllContentsSectionPreferenceBottomSheet(
                  isOrderBy: isOrder,
                  orderBy: sortBy,
                  idsList: !isOrder ? tagsIds : null,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      if (isOrder) {
        final query = await FeedContentRepository().getByFilters(
          tagsIds: tagsIds,
          sortBy: result,
        );
        setState(() {
          sortBy = result;
          data = query['data'];
          lastDoc = query['lastDoc'];
        });
      } else {
        final query = await FeedContentRepository().getByFilters(
          tagsIds: result,
          sortBy: sortBy,
        );
        setState(() {
          tagsIds = List.from(result);
          data = query['data'];
          lastDoc = query['lastDoc'];
        });
      }
    } catch (_) {}

    setState(() {
      loading = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (loading) {
      return Center(
        child: Transform.scale(
          scale: 0.5,
          child: CircularProgressIndicator(color: ColorTheme.blue),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyButton(
                      isSelected: false,
                      height: 35,
                      border: Border.all(
                        color: ColorTheme.grey.withAlpha(200),
                        width: 0.7,
                      ),
                      borderRadius: 10,
                      color: ColorTheme.grey.withAlpha(20),
                      splashColor: const Color.fromARGB(56, 255, 255, 255),
                      spaceBetween: 4,
                      text:
                          sortBy == 'popular'
                              ? 'Popular'
                              : (sortBy == 'newChap'
                                  ? 'Capítulos recentes'
                                  : 'Obras recentes'),
                      textColor: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      alignment: MainAxisAlignment.center,
                      rightIcon: PhosphorIcons.listBullets(),
                      iconColor: Colors.white,
                      iconSize: 13,
                      onTap: () async => setPreferences(true),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    flex: 1,
                    child: MyButton(
                      isSelected: false,
                      height: 35,
                      border: Border.all(
                        color: ColorTheme.grey.withAlpha(200),
                        width: 0.7,
                      ),
                      borderRadius: 10,
                      color: ColorTheme.grey.withAlpha(20),
                      splashColor: Colors.transparent,
                      spaceBetween: 4,
                      text:
                          '${tagsIds.isNotEmpty ? '+${tagsIds.length}' : ''} Categorias',
                      textColor: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      alignment: MainAxisAlignment.center,
                      rightIcon: PhosphorIcons.cardsThree(),
                      iconColor: Colors.white,
                      iconSize: 13,
                      onTap: () => setPreferences(false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              if (data != null && data!.isNotEmpty)
                ContentGrid(data: data!)
              else if (data == null || data!.isEmpty)
                NoContent(),
              if (loadMoreLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: ColorTheme.blue),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
