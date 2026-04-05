import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/models/content/chapter/chapter_model.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ChapterDisplay extends StatelessWidget {
  final bool? showOrder;
  final ContentModel? content;
  final bool? showStatus;
  final ChapterModel chapter;
  const ChapterDisplay({
    super.key,
    required this.chapter,
    this.showStatus,
    this.content,
    this.showOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (content != null) {
            context.push(
              '/dashboard/capitulos/${content!.id}/${chapter.id}/editar',
            );
          }
        },
        child: Ink(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(50, 42, 42, 42),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    if ((showOrder != null && showOrder!))
                      Text(
                        '#${chapter.order.toString()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    SizedBox(width: 10),
                    Text(
                      chapter.title == null || chapter.title!.isEmpty
                          ? 'Sem título'
                          : chapter.title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 10),
                    if (showStatus != null && showStatus!)
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          color: DashboardTheme.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            chapter.status![0].toUpperCase() +
                                chapter.status!.substring(1),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: 'Poppins',
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
  }
}
