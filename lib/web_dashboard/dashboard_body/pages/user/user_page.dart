import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
