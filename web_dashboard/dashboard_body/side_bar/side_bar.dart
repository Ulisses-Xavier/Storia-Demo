import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_body/side_bar/widgets/sections.dart';
import 'package:storia/web_dashboard/dashboard_body/side_bar/widgets/work_choice.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key});

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  bool isAdmin = false;
  String? id;

  Future<void> loadIsAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final idTokenResult = await user.getIdTokenResult(true);
        final isNowAdmin = idTokenResult.claims?['admin'] == true;

        setState(() {
          isAdmin = isNowAdmin;
          id = user.uid;
        });
      } catch (_) {
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadIsAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = GoRouter.of(context).state.uri.toString();
    return Container(
      height: double.infinity,
      width: 275.0,
      color: DashboardTheme.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 26,
                        width: 101,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              SideBarSection(
                list: [
                  SideBarItem(
                    isSelected: currentPage.contains('inicio'),
                    text: 'Início',
                    page: 'inicio',
                    icon: LucideIcons.house100,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              //
              //
              //
              //Popup Button de CRIAR
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: const Color.fromARGB(255, 25, 25, 25),
                  highlightColor: const Color.fromARGB(255, 25, 25, 25),
                ),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  color: DashboardTheme.secondary,
                  tooltip: '',
                  onSelected: (value) async {
                    if (value == 'create_work') {
                      context.go('/dashboard/obras/criar');
                    } else if (value == 'create_chapter') {
                      ContentModel? result = await showDialog<ContentModel>(
                        context: context,
                        builder: (context) {
                          return WorkChoice();
                        },
                      );

                      if (result != null) {
                        context.push('/dashboard/capitulos/${result.id}/criar');
                      }
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'create_work',
                          child: Row(
                            children: [
                              Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                  color: DashboardTheme.green,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              SizedBox(width: 5),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  'Criar obra',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'create_chapter',
                          child: Row(
                            children: [
                              Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    20,
                                    213,
                                    107,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              SizedBox(width: 5),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  'Criar capítulo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  child: MyButton(
                    text: "Criar",
                    isSelected: false,
                    height: 40.0,
                    paddingCentral: 15.0,
                    alignment: MainAxisAlignment.center,
                    onHover: Color.fromARGB(255, 42, 70, 142),
                    fontSize: 15.0,
                    color: DashboardTheme.blue,
                    borderRadius: 10.0,
                    splashColor: Color.fromARGB(255, 42, 70, 142),
                    iconColor: Colors.white,
                    iconSize: 15.0,
                    rightIcon: LucideIcons.arrowDownRight,
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              SideBarSection(
                list: [
                  SideBarItem(
                    text: 'Obras',
                    icon: LucideIcons.libraryBig100,
                    page: 'obras',
                    isSelected: currentPage.contains('obras'),
                  ),
                  SideBarItem(
                    text: 'Capítulos',
                    icon: LucideIcons.bookOpen100,
                    isSelected: false,
                    currentPage: currentPage,
                    mainPage: 'capitulos',
                    page: 'capitulos/publicados',
                    children: [
                      SideBarItem(
                        text: 'Publicados',
                        page: "capitulos/publicados",
                        isSelected: currentPage.contains(
                          'capitulos/publicados',
                        ),
                        isSub: true,
                        icon: LucideIcons.plus,
                      ),
                      SideBarItem(
                        text: 'Agendados',
                        page: 'capitulos/agendados',
                        isSelected: currentPage.contains('capitulos/agendados'),
                        isSub: true,
                        icon: LucideIcons.plus,
                      ),
                      SideBarItem(
                        text: 'Rascunhos',
                        page: 'capitulos/rascunhos',
                        isSelected: currentPage.contains('capitulos/rascunhos'),
                        isSub: true,
                        icon: LucideIcons.plus,
                      ),
                    ],
                  ),
                ],
                title: 'Conteúdo',
              ),
              const SizedBox(height: 20.0),
              SideBarSection(
                list: [
                  SideBarItem(
                    text: 'Perfil',
                    icon: LucideIcons.circleUserRound100,
                    page: 'perfil',
                    isSelected: currentPage.contains('perfil'),
                  ),
                  SideBarItem(
                    text: 'Faturamento',
                    icon: LucideIcons.wallet100,
                    page: 'faturamento',
                    isSelected: currentPage.contains('faturamento'),
                  ),
                ],
                title: 'Espaço do Usuário',
              ),
              const SizedBox(height: 20.0),
              if (isAdmin)
                SideBarSection(
                  list: [
                    SideBarItem(
                      text: 'Layout',
                      icon: LucideIcons.layoutDashboard100,
                      page: 'layout/banners',
                      currentPage: currentPage,
                      mainPage: 'layout',
                      isSelected: false,
                      children: [
                        SideBarItem(
                          text: 'Banners',
                          page: 'layout/banners',
                          isSelected: currentPage.contains('banners'),
                          isSub: true,
                          icon: LucideIcons.plus,
                        ),
                        SideBarItem(
                          text: 'Listas',
                          page: 'layout/lists',
                          isSelected: currentPage.contains('lists'),
                          isSub: true,
                          icon: LucideIcons.plus,
                        ),
                      ],
                    ),
                    SideBarItem(
                      text: 'Administração',
                      icon: LucideIcons.shell100,
                      page: 'admin',
                      isSelected: currentPage.contains('admin'),
                    ),
                  ],
                  title: 'Espaço do Admin',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
