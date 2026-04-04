import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/repositories/user_repository/user_repository.dart';

class ContentDetails extends StatelessWidget {
  final ContentModel content;
  const ContentDetails({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descrição:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Text(
            content.description!,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color.fromARGB(255, 197, 197, 197),
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Tags:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Wrap(
                direction: Axis.horizontal,
                spacing: 2,
                children:
                    content.tags!
                        .map(
                          (tag) => Container(
                            height: 23,
                            decoration: BoxDecoration(
                              color: ColorTheme.blue,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7.0,
                              ),
                              child: Center(
                                child: Text(
                                  tag['title'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Status:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Text(
            content.completed! ? 'Completo' : 'Em Andamento',
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color.fromARGB(255, 197, 197, 197),
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),
          SizedBox(height: 15),
          FutureBuilder(
            future: UserRepository().get(content.creatorsIds![0]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer(
                  child: Container(
                    height: 10,
                    width: 140,
                    decoration: BoxDecoration(
                      color: ColorTheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }

              final user = snapshot.data;

              if (user == null) {
                return SizedBox();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criador(a):',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: ColorTheme.blue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child:
                            user.image == null
                                ? Center(
                                  child: Icon(
                                    PhosphorIcons.user(),
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    100,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: user.image!,
                                    height: 40,
                                    width: 40,
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
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${user.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
