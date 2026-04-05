import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class TopBanner extends StatefulWidget {
  final ValueChanged<String> changeContentType;

  const TopBanner({super.key, required this.changeContentType});

  @override
  State<TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  String contentType = 'webnovel';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(
                  contentType == 'webnovel'
                      ? 'assets/images/webnovel_banner.png'
                      : 'assets/images/webtoon_banner.png',
                  height: 170,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  DashboardTheme.blue,
                  DashboardTheme.blue,
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hora de fazer história ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Primeiro de tudo, qual o tipo\nde conteúdo que você\npretende publicar?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  //Botões de Escolha
                  SizedBox(height: 20),

                  //Botão de Webnovel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyButton(
                        isSelected: contentType == 'webnovel',
                        text: 'WebNovel',
                        height: 30,
                        width: 116,
                        alignment: MainAxisAlignment.center,
                        spaceBetween: 0,
                        color: Colors.transparent,
                        selectedColor: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        textColor:
                            contentType == 'webnovel'
                                ? Colors.black
                                : Colors.white,
                        splashColor: const Color.fromARGB(30, 255, 255, 255),
                        border:
                            contentType == 'webnovel'
                                ? null
                                : Border.all(
                                  color: const Color.fromARGB(
                                    72,
                                    245,
                                    245,
                                    245,
                                  ),
                                ),
                        borderRadius: 10,
                        onTap: () {
                          setState(() {
                            widget.changeContentType('webnovel');
                            contentType = 'webnovel';
                          });
                        },
                      ),

                      SizedBox(width: 10),

                      //Botão de Webtoon
                      MyButton(
                        isSelected: contentType == 'webtoon',
                        text: 'WebToon',
                        height: 30,
                        width: 116,
                        alignment: MainAxisAlignment.center,
                        spaceBetween: 0,
                        color: Colors.transparent,
                        selectedColor: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        textColor:
                            contentType == 'webtoon'
                                ? Colors.black
                                : Colors.white,
                        splashColor: const Color.fromARGB(30, 255, 255, 255),
                        border:
                            contentType == 'webtoon'
                                ? null
                                : Border.all(
                                  color: const Color.fromARGB(
                                    72,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                        borderRadius: 10,
                        onTap: () {
                          setState(() {
                            widget.changeContentType('webtoon');
                            contentType = 'webtoon';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
