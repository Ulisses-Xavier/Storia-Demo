import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/comic_chapter_create.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/webnovel_chapter_create.dart';
import 'package:storia/web_dashboard/providers/user_contents_provider.dart';

class ChapterCreatePage extends ConsumerStatefulWidget {
  final String contentId;
  final String? chapterId;
  const ChapterCreatePage({super.key, this.chapterId, required this.contentId});

  @override
  ConsumerState<ChapterCreatePage> createState() => _ChapterCreatePageState();
}

class _ChapterCreatePageState extends ConsumerState<ChapterCreatePage> {
  @override
  Widget build(BuildContext context) {
    final userContents = ref.watch(userContentsProvider);

    return userContents.when(
      data: (contents) {
        if (contents.isEmpty) {
          return Container();
        }

        late ContentModel content;

        for (ContentModel contentModel in contents) {
          if (contentModel.id == widget.contentId) {
            content = contentModel;
          }
        }

        if (content.format == 'webnovel') {
          return WebnovelChapterCreate(
            content: content,
            chapterId: widget.chapterId,
          );
        } else {
          return ComicChapterCreate(content: content);
        }
      },
      loading: () {
        return Center(child: CircularProgressIndicator(color: ColorTheme.blue));
      },
      error: (_, _) {
        return Container();
      },
    );
  }
}
