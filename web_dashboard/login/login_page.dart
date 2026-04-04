import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/login/widgets/sections/login_area.dart';
import 'package:storia/web_dashboard/login/widgets/sections/register_area.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final ImageProvider bgImage;
  bool isLogin = true;
  @override
  void initState() {
    super.initState();
    bgImage = const AssetImage('assets/images/login_background.jpg');
  }

  void navigate(bool value) {
    setState(() {
      isLogin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final snackBarContent = ref.watch(snackBarProvider);

    //Mostrar aviso
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (snackBarContent != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: snackBarContent.message.length * 10,
                  decoration: BoxDecoration(
                    color:
                        snackBarContent.error
                            ? const Color.fromARGB(255, 153, 15, 5)
                            : DashboardTheme.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          snackBarContent.error
                              ? const Color.fromARGB(255, 178, 42, 33)
                              : const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      snackBarContent.message,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: DashboardTheme.background,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: bgImage,
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(240, 8, 16, 48),
              BlendMode.colorBurn,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      height: 600,
                      width: 390,
                      decoration: BoxDecoration(
                        color: DashboardTheme.primary.withAlpha(110),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color.fromARGB(255, 40, 40, 40),
                        ),
                      ),
                      child:
                          isLogin
                              ? LoginArea(navigate: navigate)
                              : RegisterArea(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
