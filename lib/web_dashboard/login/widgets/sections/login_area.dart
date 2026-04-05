import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/services/google_login_button.dart';
import 'package:storia/web_dashboard/login/widgets/login_text_field.dart';
import 'package:storia/web_dashboard/providers/snack_bar_provider.dart';

class LoginArea extends ConsumerStatefulWidget {
  final ValueChanged<bool> navigate;
  const LoginArea({super.key, required this.navigate});

  @override
  ConsumerState<LoginArea> createState() => _LoginAreaState();
}

class _LoginAreaState extends ConsumerState<LoginArea> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //Função de Login
  void login(BuildContext context, String email, String password) async {
    //Inicia o loading visual no botão
    setState(() {
      _isLoading = true;
    });

    final snack = ref.read(snackBarProvider.notifier);

    //VALIDAÇÃO DOS DADOS
    final isEmailOk = email.isNotEmpty && EmailValidator.validate(email);
    final isPasswordOk = password.isNotEmpty && password.length >= 6;

    if (!isEmailOk || !isPasswordOk) {
      if (!isEmailOk) {
        snack.showMessage(
          SnackBarContent(
            message: 'Por favor, insira um email válido',
            error: true,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (!isPasswordOk) {
        snack.showMessage(
          SnackBarContent(message: 'A senha deve', error: true),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      snack.showMessage(
        SnackBarContent(
          message: 'Erro ao fazer login | Tente novamente',
          error: true,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Logo e Texto Login
          Image.asset(
            'assets/images/logo.png',
            height: 27,
            width: 101,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 15),
          Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 15),
          //
          //
          //
          //TextFields Personalizados
          LoginTextField(
            fieldTitle: 'Seu Email:',
            controller: _emailController, // Use a variável do estado
            icon: LucideIcons.mail,
            hintText: 'Email',
          ),
          SizedBox(height: 15),
          LoginTextField(
            fieldTitle: 'Senha:',
            controller: _passwordController, // Use a variável do estado
            icon: LucideIcons.lock,
            hintText: '********',
            obscureText: true,
          ),
          SizedBox(height: 20),
          //
          //
          //
          //
          //
          //
          //Botão de Login
          MyButton(
            text: _isLoading ? 'Carregando...' : "Login",
            isSelected: false,
            width: 350,
            height: 40.0,
            paddingCentral: 15.0,
            alignment: MainAxisAlignment.center,
            onHover: const Color.fromARGB(255, 42, 70, 142),
            fontSize: 15.0,
            color: DashboardTheme.blue,
            borderRadius: 10.0,
            splashColor: const Color.fromARGB(255, 42, 70, 142),
            // O onTap agora chama a função de login
            onTap:
                () => login(
                  context,
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                ),
          ),
          SizedBox(height: 10),
          //
          //
          //
          //Botão de Login com Google
          GoogleLoginButton(),
          SizedBox(height: 15),
          //
          //
          //
          //Não tem uma conta?
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Text(
                  'Não tem uma conta?',
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
                      widget.navigate(false);
                    },
                    child: Text(
                      ' Cadastrar',
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
          SizedBox(height: 5),

          //
          //
          //
        ],
      ),
    );
  }
}
