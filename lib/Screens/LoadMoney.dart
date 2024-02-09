import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/Banks.dart';

import '../main.dart';
import 'UiHelper.dart';

class LoadMoney extends StatefulWidget {
  const LoadMoney({super.key});

  @override
  State<LoadMoney> createState() => _LoadMoneyState();
}

class _LoadMoneyState extends State<LoadMoney> {
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Load Wallet', style: TextStyle(color: Colors.black)),
        leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ))),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  // key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose the bank you wanna load your wallet',
                      ),
                      const SizedBox(height: 12),
                      const Banks(),
                      const SizedBox(height: 24),
                      const Text(
                        'Amount',
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        amountController,
                        "Please enter the Amount",
                        false,
                        true,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Transaction pin',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: pinController,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          hintText: 'Enter your transaction pin',
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      UiHelper.customButtom(() async {
                        String amount = amountController.text;
                        String pin = pinController.text;

                        if (amount.isEmpty || pin.isEmpty) {
                          UiHelper.customAlertbox(context,
                              "Please fill all fields: recipient's phone number, amount, and transaction PIN");
                          return;
                        }
                      }, 'Load Amount'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
