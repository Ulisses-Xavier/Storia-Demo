import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/services/auth_service.dart';
import 'package:storia/utilities/utilities.dart';

class LoginLayout extends ConsumerStatefulWidget {
  final TabController controller;
  final BuildContext rootContext;
  const LoginLayout({
    super.key,
    required this.controller,
    required this.rootContext,
  });

  @override
  ConsumerState<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends ConsumerState<LoginLayout>
    with AutomaticKeepAliveClientMixin {
  bool isGoogleButtonLoading = false;
  bool isLoginButtonLoading = false;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool emailError = false;
  bool passwordError = false;
  String emailErrorText = '';
  String passwordErrorText = '';

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  height: 60,
                  controller: emailController,
                  backgroundColor: ColorTheme.secondary,
                  hintColor: const Color.fromARGB(255, 81, 81, 81),
                  tipText: 'voce@dominio.com...',
                  borderRadius: 10,
                  icon: PhosphorIcons.envelopeSimpleOpen(),
                  iconColor: Colors.white,
                  iconSize: 20,
                  textColor: Colors.white,
                  cursorColor: ColorTheme.blue,
                  error: emailError,
                  errorText: emailErrorText,
                  errorTextSize: 11,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Senha:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  height: 60,
                  controller: passwordController,
                  backgroundColor: ColorTheme.secondary,
                  hintColor: const Color.fromARGB(255, 81, 81, 81),
                  tipText: '*****',
                  borderRadius: 10,
                  icon: PhosphorIcons.lock(),
                  iconColor: Colors.white,
                  iconSize: 20,
                  textColor: Colors.white,
                  cursorColor: ColorTheme.blue,
                  error: passwordError,
                  errorText: passwordErrorText,
                  errorTextSize: 11,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            height: 0.2,
            width: double.infinity,
            color: const Color.fromARGB(88, 255, 255, 255),
          ),
          SizedBox(height: 15),
          MyButton(
            isSelected: false,
            color: ColorTheme.blue,
            isLoading: isLoginButtonLoading,
            loadingColor: Colors.white,
            loadingSize: 0.5,
            height: 60,
            borderRadius: 10,
            alignment: MainAxisAlignment.center,
            spaceBetween: 0,
            text: 'Login',
            textColor: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            onTap: () async {
              if (isLoginButtonLoading) return;

              setState(() {
                isLoginButtonLoading = true;
              });

              String email = emailController.text.trim();
              String password = passwordController.text.trim();
              bool emailOk = EmailValidator.validate(email);
              bool passwordOk = password.length >= 6;

              if (!emailOk || !passwordOk) {
                if (!emailOk) {
                  setState(() {
                    emailError = true;
                    emailErrorText = 'Por favor, insira um email válido';
                  });
                }

                if (!passwordOk) {
                  setState(() {
                    passwordError = true;
                    passwordErrorText = 'Mínimo de 6 dígitos';
                  });
                }
                setState(() {
                  isLoginButtonLoading = false;
                });
                return;
              }

              final result = await ref
                  .read(authServiceProvider.notifier)
                  .signInWithEmailAndPassword(email, password);

              setState(() {
                isLoginButtonLoading = false;
              });
              if (result) {
                Warning.showCenterToast(context, 'Login efeituado com sucesso');
                Navigator.pop(context);
              } else {
                Warning.showCenterToast(
                  widget.rootContext,
                  'Houve um erro no login\nTente novamente',
                );
              }
            },
          ),
          SizedBox(height: 15),
          MyButton(
            isSelected: false,
            color: Colors.white,
            height: 60,
            borderRadius: 10,
            isLoading: isGoogleButtonLoading,
            loadingColor: ColorTheme.blue,
            loadingSize: 0.5,
            alignment: MainAxisAlignment.center,
            spaceBetween: 10,
            text: 'Login com Google',
            image: 'assets/images/google_logo.png',
            imageSize: 25,
            textColor: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 15,
            onTap: () async {
              if (isGoogleButtonLoading) return;

              setState(() {
                isGoogleButtonLoading = true;
              });

              final result =
                  await ref
                      .read(authServiceProvider.notifier)
                      .signInWithGoogle();

              if (result) {
                setState(() {
                  isGoogleButtonLoading = false;
                });
                Navigator.pop(context);
              }

              if (mounted) {
                setState(() {
                  isGoogleButtonLoading = false;
                });
              }
            },
          ),
          SizedBox(height: 15),
          Container(
            height: 0.2,
            width: double.infinity,
            color: const Color.fromARGB(88, 255, 255, 255),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                'Esqueceu a ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Warning.showCenterToast(
                    widget.rootContext,
                    'Houve um erro no login\nTente novamente',
                  );
                },
                child: Text(
                  'senha?',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap:
                () => widget.controller.animateTo(widget.controller.index + 1),
            child: Text(
              'Criar conta',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
