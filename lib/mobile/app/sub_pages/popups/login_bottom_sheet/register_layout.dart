import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:storia/mobile/app/sub_pages/popups/login_bottom_sheet/setProfileImage.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/repositories/names_repository.dart';
import 'package:storia/services/auth_service.dart';
import 'package:storia/utilities/utilities.dart';

class RegisterLayout extends ConsumerStatefulWidget {
  final TabController controller;
  final BuildContext rootContext;
  const RegisterLayout({
    super.key,
    required this.controller,
    required this.rootContext,
  });

  @override
  ConsumerState<RegisterLayout> createState() => _RegisterLayoutState();
}

class _RegisterLayoutState extends ConsumerState<RegisterLayout>
    with AutomaticKeepAliveClientMixin {
  bool isGoogleButtonLoading = false;
  bool next = false;
  //TEXT CONTROLLERS
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  //OBSCURE TEXT
  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  //TEXT ERROR
  bool nameError = false;
  String nameErrorText = '';
  bool emailError = false;
  String emailErrorText = '';
  bool passwordError = false;
  String passwordErrorText = '';
  bool confirmPasswordError = false;
  String confirmPasswordErrorText = '';
  bool passwordEqual = true;
  String passwordNotEqualText = 'As senhas não estão iguais';

  void changePages() {
    setState(() {
      next = !next;
    });
  }

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    nameController.addListener(() async {
      final name = nameController.text.trim();

      if (name.length >= 3) {
        final result = await NamesRepository().exists(name.toLowerCase());
        if (result) {
          setState(() {
            nameError = true;
            nameErrorText = 'Esse nome não está disponível';
          });
        } else if (nameError && !(name.length > 20) && name.length >= 3) {
          setState(() {
            nameError = false;
          });
        }
      }
    });

    emailController.addListener(() {
      if (EmailValidator.validate(emailController.text.trim()) && emailError) {
        setState(() {
          emailError = false;
        });
      }
    });

    passwordController.addListener(() {
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();
      if (password.length >= 6 && passwordError) {
        setState(() {
          passwordError = false;
        });
      }

      if (!passwordEqual && password == confirmPassword) {
        setState(() {
          passwordEqual = true;
        });
      }
    });

    confirmPasswordController.addListener(() {
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();
      if (confirmPassword.length >= 6 && confirmPasswordError) {
        setState(() {
          confirmPasswordError = false;
        });
      }

      if (!passwordEqual && password == confirmPassword) {
        setState(() {
          passwordEqual = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (next) {
      return Setprofileimage(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        changePages: changePages,
        rootContext: widget.rootContext,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome:',
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
                      backgroundColor: ColorTheme.secondary,
                      controller: nameController,
                      hintColor: const Color.fromARGB(255, 81, 81, 81),
                      tipText: 'Seu nome...',
                      borderRadius: 10,
                      icon: PhosphorIcons.user(),
                      iconColor: Colors.white,
                      iconSize: 20,
                      textColor: Colors.white,
                      cursorColor: ColorTheme.blue,
                      error: nameError,
                      errorText: nameErrorText,
                      errorTextSize: 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
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
                      backgroundColor: ColorTheme.secondary,
                      hintColor: const Color.fromARGB(255, 81, 81, 81),
                      controller: emailController,
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
                      backgroundColor: ColorTheme.secondary,
                      hintColor: const Color.fromARGB(255, 81, 81, 81),
                      tipText: '*****',
                      controller: passwordController,
                      borderRadius: 10,
                      icon: PhosphorIcons.lock(),
                      iconColor: Colors.white,
                      iconSize: 20,
                      textColor: Colors.white,
                      cursorColor: ColorTheme.blue,
                      obscureText: passwordObscureText,
                      maxLines: 1,
                      error: passwordEqual ? passwordError : true,
                      errorText:
                          passwordEqual
                              ? passwordErrorText
                              : passwordNotEqualText,
                      errorTextSize: 11,
                      rightButton: MyButton(
                        isSelected: false,
                        color: Colors.transparent,
                        splashColor: Colors.transparent,
                        height: 55,
                        width: 37,
                        icon:
                            !passwordObscureText
                                ? PhosphorIcons.eye()
                                : PhosphorIcons.eyeClosed(),
                        iconColor: const Color.fromARGB(255, 81, 81, 81),
                        iconSize: 20,
                        spaceBetween: 0,
                        alignment: MainAxisAlignment.center,
                        onTap: () {
                          setState(() {
                            passwordObscureText = !passwordObscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Confirmar Senha:',
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
                      backgroundColor: ColorTheme.secondary,
                      hintColor: const Color.fromARGB(255, 81, 81, 81),
                      tipText: '*****',
                      borderRadius: 10,
                      controller: confirmPasswordController,
                      obscureText: confirmPasswordObscureText,
                      maxLines: 1,
                      icon: PhosphorIcons.lock(),
                      iconColor: Colors.white,
                      iconSize: 20,
                      textColor: Colors.white,
                      cursorColor: ColorTheme.blue,
                      error: passwordEqual ? confirmPasswordError : true,
                      errorText:
                          passwordEqual
                              ? confirmPasswordErrorText
                              : passwordNotEqualText,
                      errorTextSize: 11,
                      rightButton: MyButton(
                        isSelected: false,
                        color: Colors.transparent,
                        splashColor: Colors.transparent,
                        height: 55,
                        width: 37,
                        icon:
                            !confirmPasswordObscureText
                                ? PhosphorIcons.eye()
                                : PhosphorIcons.eyeClosed(),
                        iconColor: const Color.fromARGB(255, 81, 81, 81),
                        iconSize: 20,
                        spaceBetween: 0,
                        alignment: MainAxisAlignment.center,
                        onTap: () {
                          setState(() {
                            confirmPasswordObscureText =
                                !confirmPasswordObscureText;
                          });
                        },
                      ),
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
                loadingColor: Colors.white,
                loadingSize: 0.5,
                height: 60,
                borderRadius: 10,
                alignment: MainAxisAlignment.center,
                spaceBetween: 10,
                text: 'Continuar',
                rightIcon: PhosphorIcons.arrowRight(),
                iconColor: Colors.white,
                iconSize: 20,
                textColor: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                onTap: () {
                  final email = emailController.text.trim();
                  final name = nameController.text.trim();
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();
                  final emailOk = EmailValidator.validate(email);
                  final nameOk = name.length >= 3;
                  final nameTooBig = name.length > 20;
                  final passwordLengthOk = password.length >= 6;
                  final confirmPasswordLengthOk = confirmPassword.length >= 6;
                  final passwordEqualOk = password == confirmPassword;

                  if (!emailOk ||
                      !nameOk ||
                      !passwordLengthOk ||
                      !passwordEqualOk ||
                      nameTooBig ||
                      !confirmPasswordLengthOk) {
                    if (!emailOk) {
                      setState(() {
                        emailError = true;
                        emailErrorText = 'Por favor, insira um email válido';
                      });
                    }
                    if (!nameOk) {
                      setState(() {
                        nameError = true;
                        nameErrorText = 'Mínimo de 3 dígitos';
                      });
                    }

                    if (nameTooBig) {
                      setState(() {
                        nameError = true;
                        nameErrorText = 'Máximo de 20 dígitos';
                      });
                    }

                    if (!passwordLengthOk) {
                      setState(() {
                        passwordError = true;
                        passwordErrorText = 'Mínimo de 6 dígitos';
                      });
                    }

                    if (!confirmPasswordLengthOk) {
                      setState(() {
                        confirmPasswordError = true;
                        confirmPasswordErrorText = 'Mínimo de 6 dígitos';
                      });
                    }

                    if (!passwordEqualOk) {
                      setState(() {
                        passwordEqual = false;
                      });
                    }
                    return;
                  }

                  if (nameError ||
                      emailError ||
                      passwordError ||
                      confirmPasswordError ||
                      !passwordEqual) {
                    return;
                  }

                  setState(() {
                    next = true;
                  });
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
                text: 'Registrar com Google',
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
              GestureDetector(
                onTap: () => widget.controller.animateTo(0),
                child: Text(
                  'Já tenho uma conta',
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
        ),
      ),
    );
  }
}
