import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/destaques_page/destaques_page.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/all_contents/all_contents.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/section_page/section_page.dart';
import 'package:storia/mobile/app/pages/home/home_widgets/sections_bar.dart';
import 'package:storia/mobile/app/sub_pages/popups/login_bottom_sheet/login_bottom_sheet.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/models/tags_model.dart';
import 'package:storia/providers/auth_state_provider.dart';
import 'package:storia/repositories/tags_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Map<String, dynamic> destaques = {
    'index': 0,
    'tag': TagsModel(title: 'Destaques', id: 'spotlight'),
  };

  Map<String, dynamic> todos = {
    'index': 1,
    'tag': TagsModel(title: 'Todos', id: 'all'),
  };

  Map<String, dynamic> section = {
    'index': 0,
    'tag': TagsModel(title: 'Destaques', id: 'spotlight'),
  };
  late final PageController sectionController;
  late final PageController homePageController;
  late Future<List<TagsModel>?> future;

  void setSection(Map<String, dynamic> newSection) {
    setState(() {
      section = newSection;
    });
  }

  @override
  void initState() {
    super.initState();
    sectionController = PageController(viewportFraction: 0.33);
    homePageController = PageController();
    future = TagsRepository().getAll();
  }

  void jumpIfNeeded(int targetIndex) {
    if (!sectionController.hasClients) return;

    final double currentPage =
        sectionController.page ?? sectionController.initialPage.toDouble();

    final double viewportFraction = sectionController.viewportFraction;
    final int visibleCount = (1 / viewportFraction).floor();

    final int firstVisible = currentPage.floor();
    final int lastVisible = firstVisible + visibleCount - 1;

    // margem de segurança
    final int safeStart = firstVisible + 1;
    final int safeEnd = lastVisible - 1;

    final bool isComfortablyVisible =
        targetIndex >= safeStart && targetIndex <= safeEnd;

    if (!isComfortablyVisible) {
      sectionController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDocumentProvider);
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(color: ColorTheme.blue),
            ),
          );
        }

        final List<Map<String, dynamic>> theData =
            snapshot.data!.map((item) => {'tag': item}).toList();

        final data = [destaques, todos, ...theData];

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('assets/images/logo.png', height: 29, width: 100),
                if (user.value == null)
                  Padding(
                    padding: EdgeInsetsGeometry.only(right: 1),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
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
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (user.value != null)
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: ColorTheme.blue,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image:
                              user.value!.image != null
                                  ? DecorationImage(
                                    image: NetworkImage(user.value!.image!),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 13),
            SectionsBar(
              section: section,
              setSection: setSection,
              controller: sectionController,
              data: data,
              homeController: homePageController,
            ),
            SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: PageView.builder(
                  itemCount: data.length,
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
                  controller: homePageController,
                  onPageChanged: (index) {
                    setState(() {
                      section = data[index];
                    });
                    jumpIfNeeded(index);
                  },
                  itemBuilder: (context, index) {
                    TagsModel page = data[index]['tag'];

                    Widget child;

                    if (page.title == "Destaques") {
                      child = DestaquesPage();
                    } else if (page.title == "Todos") {
                      child = AllContents();
                    } else {
                      child = SectionPage(tag: page);
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
