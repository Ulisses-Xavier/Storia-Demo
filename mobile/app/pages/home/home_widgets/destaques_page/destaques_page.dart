import 'package:flutter/material.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/destaques_page/banners_slide/banners_slide.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/destaques_page/content_lists/content_list.dart';
import 'package:storia/mobile/color_theme.dart';

class DestaquesPage extends StatefulWidget {
  const DestaquesPage({super.key});

  @override
  State<DestaquesPage> createState() => _DestaquesPageState();
}

class _DestaquesPageState extends State<DestaquesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BannersSlide(),
            SizedBox(height: 2),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorTheme.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Publicar no Storia?',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          child: Text(
                            'Clique aqui!',
                            maxLines: 2,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 197, 197, 197),
                              fontFamily: 'Poppins',
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            LocalContentLists(),
          ],
        ),
      ),
    );
  }
}
