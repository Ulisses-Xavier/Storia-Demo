import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/sub_pages/popups/login_bottom_sheet/login_bottom_sheet.dart';
import 'package:storia/mobile/app/sub_pages/popups/no_authenticated.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/models/user_model/subs/saved_contents.dart';
import 'package:storia/providers/auth_state_provider.dart';
import 'package:storia/repositories/user_repository/subs/saved_contents_repository.dart';
import 'package:storia/utilities/utilities.dart';

class ContentInfo extends ConsumerStatefulWidget {
  final ContentModel content;
  const ContentInfo({super.key, required this.content});

  @override
  ConsumerState<ContentInfo> createState() => _ContentInfoState();
}

class _ContentInfoState extends ConsumerState<ContentInfo> {
  bool popupOn = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);
    final savedContents = ref.watch(savedContentsProvider);

    final saved = savedContents.when(
      data: (data) {
        debugPrint(data.toString());
        return data.any((savedOne) => savedOne.contentId == widget.content.id);
      },
      error: (e, _) {
        return false;
      },
      loading: () => false,
    );

    return Stack(
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.content.cover!,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(color: Colors.grey.shade800),

              // se der erro
              errorWidget:
                  (context, url, error) =>
                      const Icon(Icons.broken_image, color: Colors.white),
            ),

            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: const Color.fromARGB(180, 0, 0, 0), // opcional
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100, right: 16, left: 16),
          child: SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.network(
                    widget.content.cover!,
                    height: 150,
                    width: 150 / 1.5,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
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
                                      widget.content.mainTag!['title'],
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
                            ],
                          ),
                          Text(
                            widget.content.title!,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.eye(),
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.content.views.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.bookmarkSimple(),
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.content.followersCount != null
                                        ? widget.content.followersCount!
                                            .toString()
                                        : '0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      MyButton(
                        isSelected: false,
                        height: 34,
                        width: 100,
                        isLoading: user.isLoading || loading,
                        loadingColor: Colors.white,
                        loadingSize: 0.3,
                        text: saved ? 'Salvo' : 'Salvar',
                        color: ColorTheme.blue,
                        alignment: MainAxisAlignment.center,
                        spaceBetween: 5,
                        textColor: Colors.white,
                        icon: PhosphorIcons.bookmarkSimple(
                          saved
                              ? PhosphorIconsStyle.fill
                              : PhosphorIconsStyle.regular,
                        ),
                        iconColor: Colors.white,
                        iconSize: 20,
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        borderRadius: 9,
                        splashColor: Colors.transparent,
                        fontWeight: FontWeight.w600,
                        onTap: () async {
                          if (user.isLoading) {
                            return;
                          } else if (user.value != null) {
                            setState(() {
                              loading = true;
                            });

                            //SE JÁ EXISTIR, RETIRA DOS SALVOS
                            if (saved) {
                              try {
                                await SavedContentsRepository(
                                  id: user.value!.uid,
                                ).delete(widget.content.id!);

                                setState(() {
                                  loading = false;
                                });
                                Warning.showCenterToast(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  'Obra retirada dos salvos',
                                );
                                return;
                              } catch (_) {
                                setState(() {
                                  loading = false;
                                });
                                Warning.showCenterToast(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  'Falha na ação\nTente novamente',
                                );
                                return;
                              }
                            }

                            try {
                              await SavedContentsRepository(
                                id: user.value!.uid,
                              ).create(
                                SavedContentsModel(
                                  contentId: widget.content.id,
                                  title: widget.content.title,
                                  savedAt: DateTime.now(),
                                ),
                                widget.content.id!,
                              );

                              setState(() {
                                loading = false;
                              });

                              Warning.showCenterToast(
                                // ignore: use_build_context_synchronously
                                context,
                                'Obra salva com sucesso',
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                              setState(() {
                                loading = false;
                              });
                              Warning.showCenterToast(
                                // ignore: use_build_context_synchronously
                                context,
                                'Falha na ação\nTente novamente',
                              );
                              return;
                            }

                            setState(() {
                              loading = false;
                            });
                            return;
                            //
                            //
                            //
                            //
                          } else {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: NoAuthenticated(
                                    isPopUp: true,
                                    color: ColorTheme.background,
                                  ),
                                );
                              },
                            );

                            if (result != null && result) {
                              showModalBottomSheet(
                                // ignore: use_build_context_synchronously
                                context: context,
                                isScrollControlled: true,
                                useRootNavigator: true,
                                backgroundColor: Colors.transparent,
                                builder: (rootContext) {
                                  return LoginBottomSheet(
                                    color: ColorTheme.background,
                                    rootContext: rootContext,
                                  );
                                },
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
