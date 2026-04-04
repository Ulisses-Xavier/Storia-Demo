import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/destaques_page/banners_slide/banner_card.dart';
import 'package:storia/models/banners_model.dart';
import 'package:storia/repositories/banners_repository.dart';

class BannersSlide extends StatefulWidget {
  const BannersSlide({super.key});

  @override
  State<BannersSlide> createState() => _BannersSlideState();
}

class _BannersSlideState extends State<BannersSlide> {
  late final Future<List<BannersModel>?> future;
  late final PageController controller;
  int banner = 1;

  static const int _initialPage = 0;

  @override
  void initState() {
    super.initState();
    future = BannersRepository().getAll();
    controller = PageController(viewportFraction: 1, initialPage: _initialPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerSize = MediaQuery.of(context).size.width - 10;

    return FutureBuilder<List<BannersModel>?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(
            color: const Color.fromARGB(255, 75, 75, 75),
            child: Container(
              width: bannerSize,
              height: bannerSize / 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 47, 47, 47),
              ),
            ),
          );
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Container(
            width: bannerSize,
            height: bannerSize / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
          );
        }

        final data = snapshot.data!;
        data.sort((a, b) => a.order!.compareTo(b.order!));

        return SizedBox(
          height: bannerSize / 1.2,
          width: bannerSize,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: PageView.builder(
                  controller: controller,
                  physics: const BouncingScrollPhysics(
                    parent: PageScrollPhysics(),
                  ),
                  onPageChanged: (value) {
                    setState(() {
                      banner = value % data.length + 1;
                    });
                  },
                  itemBuilder: (context, index) {
                    final banner = data[index % data.length];
                    final gradient = banner.gradientColor!;

                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 2),
                      child: BannerCard(
                        banner: banner,
                        gradient: gradient,
                        bannerSize: bannerSize,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 25,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(130, 50, 50, 50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Center(
                              child: Text(
                                '$banner  |  ${data.length}',
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
          ),
        );
      },
    );
  }
}
