import 'package:flutter/material.dart';

class LoadMoney extends StatefulWidget {
  const LoadMoney({super.key});

  @override
  State<LoadMoney> createState() => _LoadMoneyState();
}

class _LoadMoneyState extends State<LoadMoney> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'LoadMoney',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
