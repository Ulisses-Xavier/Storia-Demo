import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String path;
  const PageTitle({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    String title = 'Início';

    //Definição de title codicional
    switch (path) {
      case == '/dashboard/inicio':
        title = 'Início';

      case == '/dashboard/obras/criar':
        title = 'Página de criação';

      case == '/dashboard/obras':
        title = 'Seu conteúdo';

      case == '/dashboard/capitulos/publicados':
        title = 'Capítulos';

      case == '/dashboard/capitulos/agendados':
        title = 'Capítulos';

      case == '/dashboard/capitulos/rascunhos':
        title = 'Capítulos';

      case == '/dashboard/faturamento':
        title = 'Faturamento';

      case == '/dashboard/capitulos/criar':
        title = 'Criar capítulo';

      case == '/dashboard/layout':
        title = 'Layout';

      case == '/dashboard/admin':
        title = 'Admin';
    }

    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Poppins',
      ),
    );
  }
}
