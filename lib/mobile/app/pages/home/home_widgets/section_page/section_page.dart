import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/no_content.dart';
import 'package:storia/mobile/app/sub_widgets/content_grid.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/models/tags_model.dart';
import 'package:storia/repositories/content/feed_content_repository.dart';

class SectionPage extends StatefulWidget {
  final TagsModel? tag;
  const SectionPage({super.key, this.tag});

  @override
  State<SectionPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<SectionPage>
    with AutomaticKeepAliveClientMixin {
  //HERE BEGINS
  late ScrollController scrollController;
  bool initialized = false;
  bool loadMoreLoading = false;
  late final Future<Map<String, dynamic>> future;

  //RANK
  bool rank = true;

  //Data
  List<ContentModel>? data;
  DocumentSnapshot<Object?>? lastDoc;

  //INIT STATE
  @override
  void initState() {
    future = FeedContentRepository().getByTag(widget.tag!.id!);

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 500) {
        loadMore();
      }
    });
    super.initState();
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
    setState(() {
      loadMoreLoading = true;
    });
    try {
      late Map<String, dynamic> snapshot;
      snapshot = await FeedContentRepository().getByTag(
        widget.tag!.id!,
        lastDoc: lastDoc,
      );

      final newLastDoc = snapshot['lastDoc'];
      final newData = snapshot['data'];
      if (snapshot.isNotEmpty) {
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(color: ColorTheme.blue),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Container(height: 20, width: 100, color: Colors.red);
        }

        if (snapshot.data!.isEmpty) {
          return NoContent();
        }

        if (!initialized) {
          initialized = true;
          data = snapshot.data!['data'];
          lastDoc = snapshot.data!['lastDoc'];
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
                  ContentGrid(data: data!),
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
      },
    );
  }
}
