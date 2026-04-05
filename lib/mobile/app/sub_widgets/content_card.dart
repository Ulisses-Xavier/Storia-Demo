import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/models/search_model.dart';
import 'package:storia/repositories/search_repository.dart';

class ContentCard extends StatelessWidget {
  final ContentModel content;
  final bool? isAppSearch;
  const ContentCard({super.key, required this.content, this.isAppSearch});

  @override
  Widget build(BuildContext context) {
    final DateTime? date = content.lastChapterDatePost;
    final DateTime creationDate = content.creationDate!;

    final bool lastChapterDatePostOk =
        date != null && DateTime.now().difference(date).inDays <= 3;
    final bool createdOk = DateTime.now().difference(creationDate).inDays <= 3;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: content.coverLong ?? content.coverMini!,
            fit: BoxFit.cover,
            height: double.infinity,
            // enquanto carrega
            placeholder:
                (context, url) => Container(
                  color: Color.fromARGB(
                    255,
                    0,
                    0,
                    0,
                    //content.rgbColor!['r']!,
                    //content.rgbColor!['g']!,
                    //content.rgbColor!['b']!,
                  ),
                ),

            // se der erro
            errorWidget:
                (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
        Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                        //content.rgbColor!['r']!,
                        //content.rgbColor!['g']!,
                        //content.rgbColor!['b']!,
                      ),
                      Color.fromARGB(
                        220,
                        0,
                        0,
                        0,
                        //content.rgbColor!['r']!,
                        //content.rgbColor!['g']!,
                        //content.rgbColor!['b']!,
                      ),
                      Colors.transparent,
                    ],
                    begin: AlignmentGeometry.bottomCenter,
                    end: AlignmentGeometry.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        content.title!,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: content.fontFamily ?? 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(90, 255, 255, 255),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          content.views != null
                              ? content.views.toString()
                              : '0',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Color.fromARGB(80, 106, 90, 249),
            onTap: () async {
              if (isAppSearch != null && isAppSearch!) {
                try {
                  final exists = await SearchRepository().exists(content.id!);
                  if (exists) {
                    await SearchRepository().increment(content.id!);
                  } else {
                    await SearchRepository().create(
                      SearchModel(
                        title: content.title,
                        coverUrl: content.coverMini,
                        searchCount: 1,
                        mainTag: content.mainTag!['title'],
                      ),
                      content.id!,
                    );
                  }
                } catch (_) {}
              }

              // ignore: use_build_context_synchronously
              context.push('/content/${content.id}');
            },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (lastChapterDatePostOk)
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 182, 14, 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Center(
                          child: Text(
                            'UP',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 3),
                  if (createdOk)
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 182, 14, 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Center(
                          child: Text(
                            'NOVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
      ],
    );
  }
}
