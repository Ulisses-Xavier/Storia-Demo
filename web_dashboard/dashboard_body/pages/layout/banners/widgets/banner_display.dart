import 'package:flutter/material.dart';
import 'package:storia/models/banners_model.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/chapter_create/widgets/create_pages/comic_chapter_create/widgets/no_images.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class BannerDisplay extends StatelessWidget {
  final BannersModel? banner;
  const BannerDisplay({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 292,
        decoration: BoxDecoration(
          color: DashboardTheme.secondary,
          borderRadius: BorderRadius.circular(10),
          border:
              banner == null
                  ? Border.all(color: Color.fromARGB(255, 42, 42, 42))
                  : null,
          image:
              banner != null
                  ? DecorationImage(
                    image: NetworkImage(banner!.imageUrl!),
                    fit: BoxFit.cover,
                  )
                  : null,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(30, 5, 5, 5),
              blurRadius: 5,
              spreadRadius: 5,
              offset: Offset.fromDirection(1, 2),
            ),
          ],
        ),
        child:
            banner == null
                ? NoImages(color: Color.fromARGB(255, 46, 46, 46), padding: 70)
                : Stack(
                  children: [
                    //----GRADIENTE----\\
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(
                                    banner!.gradientColor!['a'] ?? 255,
                                    banner!.gradientColor!['r'] ?? 000,
                                    banner!.gradientColor!['g'] ?? 000,
                                    banner!.gradientColor!['b'] ?? 000,
                                  ),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //----TÍTULO-E-DESCRIÇÃO----\\
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner!.title ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Text(
                              banner!.description ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 7,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          if (banner!.tags != null && banner!.tags!.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              children:
                                  banner!.tags!.map((tag) {
                                    return IntrinsicWidth(
                                      child: Container(
                                        height: 17,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            tag['a'],
                                            tag['r'],
                                            tag['g'],
                                            tag['b'],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 3,
                                            ),
                                            child: Text(
                                              tag['title'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                fontSize: 5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
