import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/sub_widgets/content_grid.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/repositories/content/feed_content_repository.dart';
import 'package:storia/utilities/utilities.dart';

class LocalContentListModel {
  final String id;
  final String title;
  final String subTitle;
  final Future<Map<String, dynamic>> future;
  final Future<Map<String, dynamic>> futureForPage;
  const LocalContentListModel({
    required this.future,
    required this.futureForPage,
    required this.title,
    required this.id,
    required this.subTitle,
  });
}

class LocalContentListList {
  static List<LocalContentListModel> list = [
    LocalContentListModel(
      id: 'novidades',
      title: '📌 Novidades',
      subTitle: 'Encontre conteúdo que acaba de sair do forno!',
      future: FeedContentRepository().getRecents(limitToSix: true),
      futureForPage: FeedContentRepository().getRecents(),
    ),
    LocalContentListModel(
      id: 'populares',
      title: '🔥 Populares',
      subTitle: 'As favoritas do público estão aqui!',
      future: FeedContentRepository().getPopulars(limitToSix: true),
      futureForPage: FeedContentRepository().getPopulars(),
    ),
  ];
}

class LocalContentLists extends StatefulWidget {
  const LocalContentLists({super.key});

  @override
  State<LocalContentLists> createState() => _LocalContentListsState();
}

class _LocalContentListsState extends State<LocalContentLists> {
  final list = LocalContentListList.list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = list[index];
        return FutureBuilder(
          future: item.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }
            if (snapshot.hasError) {
              return SizedBox.shrink();
            }

            final data = snapshot.data;

            if (data == null || data.isEmpty) {
              return SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.5),
                            Text(
                              item.subTitle,
                              style: TextStyle(
                                color: const Color.fromARGB(200, 163, 163, 163),
                                fontFamily: 'Poppins',
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap:
                              () => context.push(
                                '/local-content-list/${item.id}',
                              ),
                          child: MyButton(
                            isSelected: false,
                            height: 35,
                            width: 35,
                            color: ColorTheme.secondary,
                            spaceBetween: 0,
                            alignment: MainAxisAlignment.center,
                            icon: PhosphorIcons.caretRight(),
                            iconColor: Colors.white,
                            iconSize: 17,
                            borderRadius: 100,
                            splashColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  ContentGrid(data: data['data']),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
