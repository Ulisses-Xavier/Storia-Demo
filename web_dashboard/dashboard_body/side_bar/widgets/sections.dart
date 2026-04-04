import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class SideBarItem {
  final String text;
  final bool isSelected;
  final String page;
  final String? mainPage;
  final IconData? icon;
  final String? currentPage;
  final List<SideBarItem>? children;
  final bool? isSub;
  SideBarItem({
    this.currentPage,
    this.mainPage,
    this.isSub,
    required this.isSelected,
    required this.text,
    required this.page,
    this.icon,
    this.children,
  });
}

class SideBarMenuItem extends ConsumerStatefulWidget {
  final SideBarItem item;
  final GestureTapCallback onTap;

  const SideBarMenuItem({required this.item, required this.onTap, super.key});

  @override
  ConsumerState<SideBarMenuItem> createState() => _SideBarMenuItemState();
}

class _SideBarMenuItemState extends ConsumerState<SideBarMenuItem> {
  late final ExpansibleController _controller;

  @override
  void initState() {
    super.initState();
    // Inicialize o controlador no initState
    _controller = ExpansibleController();
  }

  @override
  void didUpdateWidget(covariant SideBarMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.currentPage != null && widget.item.mainPage != null) {
      if (widget.item.currentPage!.contains(widget.item.mainPage!)) {
        _controller.expand();
      } else {
        _controller.collapse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.children != null && widget.item.children!.isNotEmpty) {
      return Theme(
        data: Theme.of(context).copyWith(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          controller: _controller,
          shape: RoundedRectangleBorder(side: BorderSide.none),
          showTrailingIcon: false,
          tilePadding: EdgeInsets.zero,
          title: SideBarButton(
            text: widget.item.text,
            icon: widget.item.icon,
            isSelected: widget.item.isSelected,
            onTap: widget.onTap,
          ),
          children:
              widget.item.children!
                  .map(
                    (subItem) => SideBarButton(
                      text: subItem.text,
                      icon: subItem.icon,
                      isSelected: subItem.isSelected,
                      isSub: subItem.isSub,
                      onTap: () => context.go('/dashboard/${subItem.page}'),
                    ),
                  )
                  .toList(),
        ),
      );
    } else {
      return SideBarButton(
        text: widget.item.text,
        icon: widget.item.icon,
        isSelected: widget.item.isSelected,
        onTap: widget.onTap,
      );
    }
  }
}

class SideBarButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final bool isSelected;
  final bool? isSub;
  final GestureTapCallback onTap;
  const SideBarButton({
    required this.onTap,
    required this.isSelected,
    this.isSub,
    this.icon,
    required this.text,
    super.key,
  });

  @override
  State<SideBarButton> createState() => _SideBarButtonState();
}

class _SideBarButtonState extends State<SideBarButton> {
  @override
  Widget build(BuildContext context) {
    return MyButton(
      text: widget.text,
      isSelected: widget.isSelected,
      selectedColor: DashboardTheme.primary,
      height: 40.0,
      onHover: DashboardTheme.primary,
      fontSize: 15.0,
      textColor:
          widget.isSub != null
              ? (widget.isSub!
                  ? (widget.isSelected
                      ? null
                      : const Color.fromARGB(181, 158, 158, 158))
                  : null)
              : null,
      iconSize: 15.0,
      invisibleIcon: widget.isSub,
      icon: widget.icon,
      borderRadius: 10.0,
      splashColor: const Color.fromARGB(255, 21, 21, 21),
      onTap: widget.onTap,
    );
  }
}

class SideBarSection extends ConsumerStatefulWidget {
  final String? title;
  final List<SideBarItem> list;
  const SideBarSection({required this.list, this.title, super.key});

  @override
  ConsumerState<SideBarSection> createState() => _SideBarSectionsState();
}

class _SideBarSectionsState extends ConsumerState<SideBarSection> {
  function(String page) {
    context.go('/dashboard/$page');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        SizedBox(height: 10.0),
        ...widget.list.map(
          (item) =>
              SideBarMenuItem(item: item, onTap: () => function(item.page)),
        ),
      ],
    );
  }
}
