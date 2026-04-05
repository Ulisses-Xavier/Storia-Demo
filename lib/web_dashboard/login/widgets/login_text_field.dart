import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class LoginTextField extends StatefulWidget {
  final String fieldTitle;
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const LoginTextField({
    required this.fieldTitle,
    required this.icon,
    this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    super.key,
  });

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            widget.fieldTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          cursorColor: const Color.fromARGB(150, 0, 0, 0),
          style: TextStyle(fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: const Color.fromARGB(140, 40, 40, 40)),
            prefixIcon: Icon(
              widget.icon,
              color: DashboardTheme.background,
              size: 25,
            ),
            suffixIcon:
                widget.obscureText
                    ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                        color: DashboardTheme.background,
                        size: 25,
                      ),
                    )
                    : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: DashboardTheme.blue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
