import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Statement extends StatefulWidget {
  const Statement({super.key});

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Statement',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
