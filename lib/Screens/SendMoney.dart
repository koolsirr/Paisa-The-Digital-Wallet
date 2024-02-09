import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/HomeScreen.dart';
import 'FetchUserData.dart';
import 'UiHelper.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  TextEditingController recipientPhoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Send Money', style: TextStyle(color: Colors.black)),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  // key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number',
                      ),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        recipientPhoneNumberController,
                        "Please enter the Receiver's Phone Number",
                        false,
                        false,
                      ),
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
                      const SizedBox(height: 12),
                      Text(
                        'Transaction pin',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
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
                      const SizedBox(height: 12,),
                      UiHelper.customButtom(() async {
                        String recipientPhoneNumber = recipientPhoneNumberController.text;
                        String amount = amountController.text;
                        String pin = pinController.text;

                        if (recipientPhoneNumber.isEmpty || amount.isEmpty || pin.isEmpty) {
                          UiHelper.customAlertbox(context,
                              "Please fill all fields: recipient's phone number, amount, and transaction PIN");
                          return;
                        }
                      }, 'Send Amount'),
                      const SizedBox(height: 12),
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
