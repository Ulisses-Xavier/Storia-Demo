import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:storia/mobile/app/sub_pages/content_page/content_page_widgets/chapters_not_found.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/content/chapter/chapter_repository.dart';

class ChaptersList extends StatefulWidget {
  final ContentModel content;
  const ChaptersList({super.key, required this.content});

  @override
  State<ChaptersList> createState() => _ChaptersListState();
}

class _ChaptersListState extends State<ChaptersList>
    with AutomaticKeepAliveClientMixin {
  bool descending = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: ChapterRepository(
        contentId: widget.content.id!,
      ).getChapterByStatus('publicado', false, '', descending: descending),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Center(child: Shimmer(child: Container(height: 10))),
          );
        }

        final data = snapshot.data;

        if (data == null) {
          return SliverToBoxAdapter(child: Center(child: ChaptersNotFound()));
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${data.length} Capítulos",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color.fromARGB(255, 197, 197, 197),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          descending = !descending;
                        });
                      },
                      child: Icon(
                        !descending
                            ? PhosphorIcons.sortDescending()
                            : PhosphorIcons.sortAscending(),
                        color: Color.fromARGB(255, 197, 197, 197),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            }

            final chapter = data[index - 1];

            return Padding(
              padding: EdgeInsets.only(bottom: 10, top: index == 0 ? 10 : 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: ColorTheme.secondary,
                  onTap: () {
                    context.push(
                      '/content/${widget.content.id}/chapter/${chapter.order}',
                    );
                  },
                  child: Ink(
                    height: 70,
                    width: 200,
                    color: ColorTheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: widget.content.coverMini!,
                                  height: 63,
                                  width: 63,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        color: Colors.grey.shade800,
                                      ),

                                  // se der erro
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Capítulo ${chapter.order.toString()}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 197, 197, 197),
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  SizedBox(
                                    width: 270,
                                    child: Text(
                                      '${chapter.title}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    '${chapter.publishedAt?.day ?? 'none'}/${chapter.publishedAt?.month ?? 'none'}/${chapter.publishedAt?.year ?? 'none'}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 197, 197, 197),
                                      fontSize: 9,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                chapter.views.toString(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                PhosphorIcons.eye(),
                                color: Colors.white,
                                size: 17,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }, childCount: data.length + 1),
        );
      },
    );
  }
}
