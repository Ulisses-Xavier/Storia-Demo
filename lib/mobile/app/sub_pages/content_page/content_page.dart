import 'package:flutter/material.dart';
import 'package:storia/mobile/app/sub_pages/content_page/content_page_widgets/chapters_list.dart';
import 'package:storia/mobile/app/sub_pages/content_page/content_page_widgets/content_details.dart';
import 'package:storia/mobile/app/sub_pages/content_page/content_page_widgets/content_info.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/content_repository.dart';

class ContentPage extends StatefulWidget {
  final String id;
  const ContentPage({super.key, required this.id});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late final Future<ContentModel?> future;
  @override
  void initState() {
    future = ContentRepository().get(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ContentModel?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: ColorTheme.background,
            body: Center(
              child: CircularProgressIndicator(color: ColorTheme.blue),
            ),
          );
        }

        final ContentModel content = snapshot.data!;

        return Scaffold(
          backgroundColor: ColorTheme.secondary,
          body: DefaultTabController(
            length: 2,
            child: ScrollConfiguration(
              behavior: ScrollBehavior().copyWith(overscroll: false),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverAppBar(
                        pinned: true,
                        expandedHeight: 295,
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: ColorTheme.background,
                        shadowColor: ColorTheme.background,
                        surfaceTintColor: ColorTheme.background,
                        title: Text(
                          content.title!,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: ContentInfo(content: content),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(kToolbarHeight),
                          child: ColoredBox(
                            color: ColorTheme.background,
                            child: const TabBar(
                              labelColor: Colors.white,
                              dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Color.fromARGB(
                                110,
                                255,
                                255,
                                255,
                              ),
                              indicatorWeight: 2,
                              tabs: [
                                Tab(text: 'Capítulos'),
                                Tab(text: 'Detalhes'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },

                body: TabBarView(
                  children: [
                    Builder(
                      builder: (context) {
                        return CustomScrollView(
                          slivers: [
                            SliverOverlapInjector(
                              handle:
                                  NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context,
                                  ),
                            ),
                            ChaptersList(content: content),
                          ],
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        return CustomScrollView(
                          slivers: [
                            SliverOverlapInjector(
                              handle:
                                  NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context,
                                  ),
                            ),

                            SliverToBoxAdapter(
                              child: ContentDetails(content: content),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
