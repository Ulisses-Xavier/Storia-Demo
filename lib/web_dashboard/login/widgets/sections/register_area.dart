import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/services/google_login_button.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/login/widgets/login_text_field.dart';
import 'package:storia/web_dashboard/login/widgets/sections/image_area.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class RegisterArea extends ConsumerStatefulWidget {
  final ValueChanged<bool> navigate;
  const RegisterArea({super.key, required this.navigate});

  @override
  ConsumerState<RegisterArea> createState() => _RegisterAreaState();
}

class _RegisterAreaState extends ConsumerState<RegisterArea> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _anotherpasswordController;

  bool canNavigate = false;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _anotherpasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _anotherpasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void save() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String anotherPassword = _anotherpasswordController.text;

    bool isNameTooSmall = name.length < 3;
    bool isPasswordTooSmall = password.length < 6;
    bool arePasswordsEqual = password == anotherPassword;
    bool isEmailOk = EmailValidator.validate(email);

    final message = ref.read(snackBarProvider.notifier);

    if (name.isEmpty) {
      message.showMessage(
        SnackBarContent(message: 'Por favor, defina um nome', error: true),
      );
      return;
    } else if (isNameTooSmall) {
      message.showMessage(
        SnackBarContent(
          message: 'Seu nome deve ter o mínimo de 4 caracteres',
          error: true,
        ),
      );
      return;
    }

    if (email.isEmpty) {
      message.showMessage(
        SnackBarContent(message: 'Por favor, insira um email', error: true),
      );
      return;
    } else if (!isEmailOk) {
      message.showMessage(
        SnackBarContent(
          message: 'Por favor, insira um email válido',
          error: true,
        ),
      );
      return;
    }

    if (isPasswordTooSmall) {
      message.showMessage(
        SnackBarContent(
          message: 'A senha deve ter um mínimo de 6 dígitos',
          error: true,
        ),
      );
      return;
    } else if (!arePasswordsEqual) {
      message.showMessage(
        SnackBarContent(message: 'Suas senhas são diferentes', error: true),
      );
      return;
    }

    setState(() {
      data = {'name': name, 'email': email, 'password': password};
      canNavigate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child:
          canNavigate
              ? ImageArea(key: const ValueKey('image_area'), data: data)
              : Padding(
                key: const ValueKey('form_area'),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Registro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),

                    LoginTextField(
                      fieldTitle: 'Seu nome:',
                      icon: LucideIcons.user,
                      hintText: 'Nome',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 15),

                    LoginTextField(
                      fieldTitle: 'Seu email',
                      icon: LucideIcons.mail,
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),

                    LoginTextField(
                      fieldTitle: 'Insira uma senha:',
                      icon: LucideIcons.lock,
                      hintText: '******',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    LoginTextField(
                      fieldTitle: 'Confirme a senha:',
                      icon: LucideIcons.lock,
                      hintText: '******',
                      controller: _anotherpasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    MyButton(
                      isSelected: false,
                      color: DashboardTheme.blue,
                      text: "Continuar",
                      spaceBetween: 0,
                      fontSize: 15,
                      alignment: MainAxisAlignment.center,
                      onHover: DashboardTheme.blue,
                      height: 40,
                      borderRadius: 10,
                      onTap: save,
                    ),

                    const SizedBox(height: 10),
                    GoogleLoginButton(),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          const Text(
                            'Já tem uma conta?',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 10,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                widget.navigate(true);
                              },
                              child: const Text(
                                ' Fazer login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
