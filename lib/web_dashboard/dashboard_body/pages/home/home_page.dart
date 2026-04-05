import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Row(children: [Expanded(child: WorkInProgressWidget())]),
        ],
      ),
    );
  }
}
