import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/color_theme.dart';

class BarIcon extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final String page;
  const BarIcon({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 60,
      child: InkWell(
        onTap: () => context.go('/$page'),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 3),
              Icon(
                isSelected ? selectedIcon : icon,
                color:
                    isSelected
                        ? Colors.white
                        : const Color.fromARGB(200, 106, 106, 106),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    final currentPage = GoRouter.of(context).state.uri.toString();
    return Container(
      height: 50,
      color: ColorTheme.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarIcon(
              icon: PhosphorIcons.house(),
              isSelected: currentPage == '/home',
              selectedIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
              page: 'home',
            ),
            BarIcon(
              icon: PhosphorIcons.magnifyingGlass(),
              isSelected: currentPage == '/search',
              selectedIcon: PhosphorIcons.magnifyingGlass(
                PhosphorIconsStyle.fill,
              ),
              page: 'search',
            ),
            BarIcon(
              icon: PhosphorIcons.bookmarkSimple(),
              isSelected: currentPage == '/library',
              selectedIcon: PhosphorIcons.bookmarkSimple(
                PhosphorIconsStyle.fill,
              ),
              page: 'library',
            ),
            BarIcon(
              icon: PhosphorIcons.list(),
              isSelected: currentPage == '/more',
              selectedIcon: PhosphorIcons.list(PhosphorIconsStyle.bold),
              page: 'more',
            ),
          ],
        ),
      ),
    );
  }
}
