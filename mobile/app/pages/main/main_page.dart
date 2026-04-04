import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storia/mobile/app/pages/main/app_bar.dart';
import 'package:storia/mobile/color_theme.dart';

class MainPage extends StatelessWidget {
  final Widget page;
  const MainPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorTheme.background,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                right: 6,
                left: 6,
                bottom: 45,
              ),
              child: page,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [MyAppBar()],
            ),
          ],
        ),
      ),
    );
  }
}
