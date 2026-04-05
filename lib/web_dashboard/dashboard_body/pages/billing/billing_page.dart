import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

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
