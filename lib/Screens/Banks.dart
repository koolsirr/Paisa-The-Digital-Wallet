import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Banks extends StatefulWidget {
  const Banks({super.key});

  @override
  State<Banks> createState() => _BanksState();
}

class _BanksState extends State<Banks> {

  List<String> items = ['Bank 1', 'Bank 2', 'Bank 3', 'Bank 4'];

  String selectedItem = 'Bank 1';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedItem,
      onChanged: (String? newValue) {
        setState(() {
          selectedItem = newValue!;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isExpanded: true,
    );
  }
}
