import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/works/widgets/data_display.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class WorksList extends StatefulWidget {
  final List<ContentModel> contentList;
  const WorksList({super.key, required this.contentList});

  @override
  State<WorksList> createState() => _WorksListState();
}

class _WorksListState extends State<WorksList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              widget.contentList.map((content) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width / 2) - 30,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: const Color.fromARGB(255, 21, 21, 21),
                      highlightColor: const Color.fromARGB(255, 21, 21, 21),
                      onTap: () async {
                        context.go('/dashboard/obras/${content.id}/editar');
                      },
                      child: Ink(
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // cover
                            Container(
                              height: 140,
                              width: 93,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(98, 70, 70, 70),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  content.coverMini ?? content.cover!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // texts
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      content.title ?? "Idenfinido",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Row(
                                      children: [
                                        DataDisplay(
                                          icon: LucideIcons.eye,
                                          value: content.views.toString(),
                                          title: 'Views',
                                        ),
                                        SizedBox(width: 12),
                                        DataDisplay(
                                          icon: PhosphorIcons.heart(),
                                          value:
                                              content.likes != null
                                                  ? content.likes.toString()
                                                  : '0',
                                          title: 'Likes',
                                        ),
                                        SizedBox(width: 12),
                                        DataDisplay(
                                          icon: LucideIcons.usersRound,
                                          value:
                                              content.followersCount != null
                                                  ? content.followersCount
                                                      .toString()
                                                  : '0',
                                          title: 'Seguidores',
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: DashboardTheme.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        content.format ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
