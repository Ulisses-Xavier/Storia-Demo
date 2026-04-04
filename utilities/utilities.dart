import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}

String formatHour(DateTime date) {
  return "${date.hour.toString().padLeft(2, '0')}:"
      "${date.minute.toString().padLeft(2, '0')}";
}

//Botão Personalizado
class MyButton extends StatefulWidget {
  final double? borderRadius;
  final Color? color;
  final double? width;
  final String? text;
  final IconData? icon;
  final double? height;
  final Color? iconColor;
  final double? iconSize;
  final LinearGradient? gradient;
  final bool? isLoading;
  final bool? invisibleIcon;
  final MainAxisAlignment? alignment;
  final GestureTapCallback? onTap;
  final Color? onHover;
  final Color? splashColor;
  final Color? loadingColor;
  final bool isSelected;
  final Color? selectedColor;
  final double? spaceBetween;
  final Color? textColor;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? loadingWidth;
  final double? loadingSize;
  final double? fontSize;
  final double? paddingCentral;
  final IconData? rightIcon;
  final Border? border;
  final String? image;
  final double? imageSize;
  const MyButton({
    this.image,
    this.imageSize,
    this.color,
    this.loadingColor,
    this.width,
    this.isLoading,
    this.border,
    this.height,
    this.loadingWidth,
    this.rightIcon,
    this.paddingCentral,
    this.gradient,
    this.loadingSize,
    this.fontSize,
    this.fontFamily,
    required this.isSelected,
    this.textColor,
    this.invisibleIcon,
    this.selectedColor,
    this.splashColor,
    this.spaceBetween,
    this.borderRadius,
    this.onHover,
    this.icon,
    this.text,
    this.iconColor,
    this.onTap,
    this.alignment,
    this.fontWeight,
    this.iconSize,
    super.key,
  });

  @override
  State<MyButton> createState() => _SideBarButtonState();
}

class _SideBarButtonState extends State<MyButton> {
  bool _isHover = false;
  @override
  Widget build(BuildContext context) {
    Color color =
        widget.isSelected
            ? (widget.selectedColor ?? Colors.transparent)
            : _isHover
            ? (widget.onHover ?? Colors.transparent)
            : (widget.color ?? Colors.transparent);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter:
          (event) => setState(() {
            _isHover = true;
          }),
      onExit:
          (event) => setState(() {
            _isHover = false;
          }),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: widget.splashColor ?? Colors.grey,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0.0),
          mouseCursor: SystemMouseCursors.click,
          child: Ink(
            width: widget.width ?? double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0.0),
              color: widget.gradient == null ? color : null,
              gradient: widget.gradient,
              border: widget.border,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.paddingCentral ?? 8,
              ),
              child:
                  widget.isLoading != null && widget.isLoading!
                      ? Center(
                        child: Transform.scale(
                          scale: widget.loadingSize,
                          child: CircularProgressIndicator(
                            color: widget.loadingColor,
                            strokeWidth: widget.loadingWidth,
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment:
                            widget.alignment ?? MainAxisAlignment.start,
                        children: [
                          if (widget.icon != null)
                            Icon(
                              widget.icon,
                              color:
                                  widget.invisibleIcon != null
                                      ? (widget.invisibleIcon! == true
                                          ? Colors.transparent
                                          : widget.iconColor ?? Colors.white)
                                      : widget.iconColor ?? Colors.white,
                              size: widget.iconSize ?? 10,
                            ),
                          if (widget.image != null)
                            Image.asset(
                              widget.image!,
                              height: widget.imageSize,
                              width: widget.imageSize,
                            ),
                          SizedBox(width: widget.spaceBetween ?? 10),
                          if (widget.text != null)
                            Text(
                              widget.text!,
                              style: TextStyle(
                                color: widget.textColor ?? Colors.white,
                                fontSize: widget.fontSize ?? 10,
                                fontFamily: widget.fontFamily,
                                fontWeight:
                                    widget.fontWeight ?? FontWeight.normal,
                              ),
                            ),
                          SizedBox(width: widget.spaceBetween ?? 10),
                          if (widget.rightIcon != null)
                            Icon(
                              widget.rightIcon,
                              color: widget.iconColor ?? Colors.white,
                              size: widget.iconSize ?? 10,
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

//
//
//
//
//
//
//
//TextField Personalizado
class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final String? tipText;
  final String? errorText;
  final bool? error;
  final IconData? icon;
  final Color? iconColor;
  final bool? expands;
  final double? iconSize;
  final double? distanceBetween;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool? obscureText;
  final BoxBorder? border;
  final int? maxLines;
  final Color? textColor;
  final Color? hintColor;
  final bool? isNumber;
  final MyButton? rightButton;
  final Color? cursorColor;
  final double? fontSize;
  final double? errorTextSize;
  final Widget? eraseButton;
  final double? distanceBetweenButtons;
  final TextInputAction? textInputAction;
  final CrossAxisAlignment? crossAxisAlignment;
  final ValueChanged<String>? function;
  const MyTextField({
    this.rightButton,
    this.fontSize,
    this.function,
    this.textInputAction,
    this.maxLines,
    this.isNumber,
    this.error,
    this.distanceBetweenButtons,
    this.obscureText,
    this.eraseButton,
    this.errorTextSize,
    this.textColor,
    this.crossAxisAlignment,
    this.errorText,
    this.cursorColor,
    this.expands,
    this.hintColor,
    this.controller,
    this.iconColor,
    this.distanceBetween,
    this.iconSize,
    super.key,
    this.height,
    this.width,
    this.tipText,
    this.icon,
    this.backgroundColor,
    this.borderRadius,
    this.border,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            border:
                widget.error != null
                    ? (widget.error!
                        ? Border.all(color: Colors.red)
                        : widget.border)
                    : widget.border,
          ),
          //
          //
          //
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment:
                  widget.crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: widget.iconSize,
                  ),
                SizedBox(width: widget.distanceBetween ?? 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: widget.controller,
                      textInputAction: widget.textInputAction,
                      obscureText:
                          widget.obscureText != null
                              ? widget.obscureText!
                              : false,
                      keyboardType:
                          widget.isNumber != null && widget.isNumber!
                              ? TextInputType.number
                              : null,
                      inputFormatters:
                          widget.isNumber != null && widget.isNumber!
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : null,
                      cursorColor: widget.cursorColor,
                      maxLines: widget.maxLines,
                      onFieldSubmitted: widget.function,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        color: widget.textColor ?? Colors.white,
                        fontSize: widget.fontSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200,
                      ),
                      expands: widget.expands ?? false,
                      decoration: InputDecoration(
                        hintText: widget.tipText,
                        hintStyle: TextStyle(color: widget.hintColor),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isCollapsed: true, // mantém alinhado como no TextField
                      ),
                    ),
                  ),
                ),
                if (widget.eraseButton != null) widget.eraseButton!,
                if (widget.distanceBetweenButtons != null)
                  SizedBox(width: widget.distanceBetweenButtons),
                //RightButton
                if (widget.rightButton != null) widget.rightButton!,
              ],
            ),
          ),
        ),
        //
        // Error text
        if (widget.error != null && widget.error!)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              widget.errorText ?? '',
              style: TextStyle(
                color: Colors.red,
                fontSize: widget.errorTextSize,
              ),
            ),
          ),
      ],
    );
  }
}

//
//
//
//
//
//
//
//Remember Me Field Personalizado
class MyRememberMe extends StatefulWidget {
  final double boxSize;
  final bool accepted;
  final Color? color;
  final GestureTapCallback? function;
  final IconData deniedIcon;
  final Color? splashColor;
  final IconData acceptedIcon;
  final double? borderRadius;
  final String text;
  final String? fontFamily;
  final double? fontSize;
  const MyRememberMe({
    required this.accepted,
    required this.text,
    this.fontFamily,
    this.fontSize,
    this.function,
    this.borderRadius,
    this.splashColor,
    this.color,
    required this.deniedIcon,
    required this.acceptedIcon,
    required this.boxSize,
    super.key,
  });

  @override
  State<MyRememberMe> createState() => _MyRememberMeState();
}

class _MyRememberMeState extends State<MyRememberMe> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.function,
            splashColor: widget.splashColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            child: Ink(
              height: widget.boxSize,
              width: widget.boxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              ),
              child: Center(
                child: Icon(
                  widget.accepted ? widget.acceptedIcon : widget.deniedIcon,
                  color: widget.color ?? Colors.white,
                  size: widget.boxSize,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          widget.text,
          style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontFamily: widget.fontFamily,
          ),
        ),
      ],
    );
  }
}

class EmailValidator {
  static bool validate(String email) {
    if (email.isEmpty) return false;

    final regex = RegExp(
      r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    );

    return regex.hasMatch(email);
  }
}

class Warning {
  static void showCenterToast(
    BuildContext context,
    String message, {
    double? height,
    double? width,
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;
    double opacity = 0.0;

    entry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: opacity,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: height,
                    width: width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);

    // Fade in
    Future.delayed(const Duration(milliseconds: 50), () {
      opacity = 1.0;
      entry.markNeedsBuild();
    });

    // Fade out
    Future.delayed(const Duration(seconds: 2), () {
      opacity = 0.0;
      entry.markNeedsBuild();
    });

    // Remove
    Future.delayed(const Duration(milliseconds: 2300), () {
      entry.remove();
    });
  }
}

class NormalizeString {
  static String normalizeString(String text) {
    final lower = text.toLowerCase().trim();

    // Remove acentos
    const withAccents = 'áàãâäéèêëíìîïóòõôöúùûüç';
    const withoutAccents = 'aaaaaeeeeiiiiooooouuuuc';

    var result = lower;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return result;
  }
}
