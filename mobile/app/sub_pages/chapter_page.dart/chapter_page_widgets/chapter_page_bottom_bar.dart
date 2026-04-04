import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChapterPageBottomBar extends StatefulWidget {
  final bool showUi;
  final String contentId;
  final int? next;
  final int? previous;
  final ValueChanged<int> setFuture;
  const ChapterPageBottomBar({
    super.key,
    required this.showUi,
    required this.contentId,
    required this.next,
    required this.previous,
    required this.setFuture,
  });

  @override
  State<ChapterPageBottomBar> createState() => _ChapterPageBottomBarState();
}

class _ChapterPageBottomBarState extends State<ChapterPageBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: AnimatedOpacity(
        opacity: widget.showUi ? 1 : 0,
        duration: const Duration(milliseconds: 2000),
        child: AnimatedSlide(
          offset: widget.showUi ? Offset(0, 0) : Offset(0, -1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            height: 50,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:
                        () =>
                            widget.previous != null
                                ? widget.setFuture(widget.previous!)
                                : null,
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.caretLeft(),
                          color:
                              widget.previous != null
                                  ? Colors.white
                                  : const Color.fromARGB(87, 255, 255, 255),
                          size: 30,
                        ),
                        Text(
                          'Anterior',
                          style: TextStyle(
                            color:
                                widget.previous != null
                                    ? Colors.white
                                    : const Color.fromARGB(87, 255, 255, 255),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    PhosphorIcons.heart(),
                    color: const Color.fromARGB(145, 255, 255, 255),
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap:
                        () =>
                            widget.next != null
                                ? widget.setFuture(widget.next!)
                                : null,
                    child: Row(
                      children: [
                        Text(
                          'Próximo',
                          style: TextStyle(
                            color:
                                widget.next != null
                                    ? Colors.white
                                    : const Color.fromARGB(87, 255, 255, 255),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          PhosphorIcons.caretRight(),
                          color:
                              widget.next != null
                                  ? Colors.white
                                  : const Color.fromARGB(87, 255, 255, 255),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
