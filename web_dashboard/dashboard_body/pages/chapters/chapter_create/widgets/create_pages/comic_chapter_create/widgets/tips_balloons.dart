import 'package:flutter/material.dart';

List<String> tipsBalloonsModels = [
  'Altura Máx.: 10.000px',
  'Largura Máx.: 1024px',
  'Tamanho de Arquivo: Máx. 5MB',
  'Tipos de Arquivo Aceitos: Webp, Jpeg, PNG',
  'Tipo Recomendado: Webp',
];

List<String> tipsForCover = [
  'Altura Máx: 1024px',
  'Largura Máx.: 1024px',
  'Tamanho de Arquivo: Máx. 1MB',
  'Webp, Jpeg, PNG',
];

class TipsBalloons extends StatelessWidget {
  final bool? isCover;
  const TipsBalloons({super.key, this.isCover});

  @override
  Widget build(BuildContext context) {
    List<String> tips = tipsBalloonsModels;
    if (isCover != null && isCover == true) {
      tips = tipsForCover;
    }
    return Expanded(
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children:
            tips.map((tip) {
              return Container(
                height: 20,
                width: tip.length * 5 + 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 56, 92, 182),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(80, 121, 195, 255),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tip,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
