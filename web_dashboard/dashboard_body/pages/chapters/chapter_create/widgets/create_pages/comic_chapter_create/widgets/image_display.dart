import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ImageDisplay extends StatefulWidget {
  final int position;
  final Uint8List image;
  final ValueChanged<int> orderUp;
  final ValueChanged<int> orderDown;
  final String imageName;
  final bool edit;
  final ValueChanged<String> deleteImage;
  final String id;
  const ImageDisplay({
    super.key,
    required this.position,
    required this.orderUp,
    required this.edit,
    required this.id,
    required this.orderDown,
    required this.deleteImage,
    required this.image,
    required this.imageName,
  });

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  //Hover logic for the trash button
  bool isHovering = false;
  void hovering(bool newValue) {
    setState(() {
      isHovering = newValue;
    });
  }

  //Hover logic for the up arrow button
  bool isUpHovering = false;
  void upHovering(bool newValue) {
    setState(() {
      isUpHovering = newValue;
    });
  }

  //Hover logic for the up arrow button
  bool isDownHovering = false;
  void downHovering(bool newValue) {
    setState(() {
      isDownHovering = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Imagem, nome
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                widget.image,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '${widget.position}. ${widget.imageName}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ],
        ),

        widget.edit
            ? Row(
              children: [
                InkWell(
                  onTap: () {
                    widget.orderUp(widget.position - 1);
                  },
                  onHover: upHovering,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: Icon(
                        LucideIcons.chevronUp,
                        color:
                            isUpHovering
                                ? const Color.fromARGB(146, 255, 255, 255)
                                : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.orderDown(widget.position - 1);
                  },
                  onHover: downHovering,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: Icon(
                        LucideIcons.chevronDown,
                        color:
                            isDownHovering
                                ? const Color.fromARGB(146, 255, 255, 255)
                                : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
            : //BOTÃO DE APAGAR
            InkWell(
              onTap: () {
                widget.deleteImage(widget.id);
              },
              onHover: hovering,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    LucideIcons.trash2,
                    color:
                        isHovering
                            ? const Color.fromARGB(146, 244, 67, 54)
                            : Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
