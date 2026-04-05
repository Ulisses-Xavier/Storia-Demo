import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/models/banners_model.dart';

class BannerCard extends StatelessWidget {
  final BannersModel banner;
  final double bannerSize;
  final Map<String, int> gradient;
  const BannerCard({
    super.key,
    required this.banner,
    required this.gradient,
    required this.bannerSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: CachedNetworkImage(
            imageUrl: banner.imageUrl!,
            fit: BoxFit.cover,
            height: double.infinity,
            width: bannerSize,

            // enquanto carrega
            placeholder:
                (context, url) => Container(
                  color: Color.fromARGB(
                    gradient['a']!,
                    gradient['r']!,
                    gradient['g']!,
                    gradient['b']!,
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
                height: double.infinity,
                width: bannerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(
                        gradient['a']!,
                        0,
                        0,
                        0,
                        //content.rgbColor!['r']!,
                        //content.rgbColor!['g']!,
                        //content.rgbColor!['b']!,
                      ),
                      Color.fromARGB(
                        170,
                        0,
                        0,
                        0,
                        //content.rgbColor!['r']!,
                        //content.rgbColor!['g']!,
                        //content.rgbColor!['b']!,
                      ),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner.title ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
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
                          banner.description ?? '',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      if (banner.tags != null && banner.tags!.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children:
                              banner.tags!.map((tag) {
                                return IntrinsicWidth(
                                  child: Container(
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(
                                        tag['a'],
                                        tag['r'],
                                        tag['g'],
                                        tag['b'],
                                      ),
                                      borderRadius: BorderRadius.circular(4),
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
                                            fontSize: 10,
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
              ),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: const Color.fromARGB(5, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              context.push(banner.route!);
            },
            child: Ink(
              height: bannerSize / 1.2,
              width: bannerSize,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
