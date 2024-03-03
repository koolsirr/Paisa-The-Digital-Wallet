import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../KYC/OCR/FetchData.dart';
import 'FetchUserData.dart';
import 'UiHelper.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  String? senderEmail;
  String? receiverEmail;
  String? userPin;
  num? senderBalance;
  num? receiverBalance;
  String? senderBalanceString;
  String? receiverBalanceString;
  bool userExists = false;
  bool check = true;

  TextEditingController recipientEmailController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    senderEmail = await UserDataService.fetchUserData('Email');
    senderBalanceString = await UserDataService.fetchUserData('Balance');
    senderBalance = int.tryParse(senderBalanceString!);
    userPin = await UserDataService.fetchUserData('Transaction Pin');
    setState(() {});
  }

  Future<void> fetchData(String userEmail, BuildContext context) async {
    receiverEmail = await FetchEmail.fetchUserEmail(userEmail);
    print('$receiverEmail');

    if (receiverEmail != null) {
      setState(() {
        userExists = true;
        check = false;
      });

      receiverBalanceString = await FetchData.fetchData(receiverEmail!, 'Balance');
      print('$receiverBalanceString');

      if (receiverBalanceString != null) {
        receiverBalance = int.tryParse(receiverBalanceString!);
        print('$receiverBalance');
      } else {
        print('Failed to fetch receiver balance.');
      }
    } else {
      print('User does not exist.');
      // Show a Snackbar to indicate that the user does not exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User does not exist.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> sendBalance(String rEmail) async {
    senderEmail = await UserDataService.fetchUserData('Email');
    receiverEmail = await FetchEmail.fetchUserEmail(rEmail);
    receiverBalanceString = await FetchData.fetchData(receiverEmail!, 'Balance');
    receiverBalance = int.tryParse(receiverBalanceString!);
    senderBalanceString = await UserDataService.fetchUserData('Balance');
    senderBalance = int.tryParse(senderBalanceString!);
    String amountText = amountController.text;

    if (pinController.text.isEmpty || amountController.text.isEmpty) {
      UiHelper.customAlertbox(
          context, "Please fill all fields: amount and transaction PIN");
      return;
    }

    num amount = int.tryParse(amountText)!;

    if (amount <= 0) {
      UiHelper.customAlertbox(
          context,
          "Amount should be greater than zero"
      );
      return;
    }

    if (senderBalance! < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient balance.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }


    if (pinController.text == userPin) {
      num amountToAdd = int.tryParse(amountController.text) as num;

      if (amountToAdd > 100000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Amount cannot exceed Rs. 100000'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      num newSBalance = (senderBalance)! - amountToAdd;
      String newSBalanceString = newSBalance.toString();

      try {

        // QuerySnapshot querySSnapshot = await FirebaseFirestore.instance
        //     .collection('Users')
        //     .where('Email', isEqualTo: senderEmail)
        //     .get();
        // print('sent by: $senderEmail');

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(senderEmail)
            .update({
          'Balance': newSBalanceString,
          'Transactions': FieldValue.arrayUnion([{
            'amount': amountToAdd,
            'type': 'debit', // Assuming loading money adds to the balance
            'timestamp': Timestamp.now(),
          }])
        });

        num newRBalance = (receiverBalance)! + amountToAdd;
        String newRBalanceString = newRBalance.toString();

        // QuerySnapshot queryRSnapshot = await FirebaseFirestore.instance
        //     .collection('Users')
        //     .where('Email', isEqualTo: receiverEmail)
        //     .get();
        // print('received by $receiverEmail');

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(receiverEmail)
            .update({
          'Balance': newRBalanceString,
          'Transactions': FieldValue.arrayUnion([{
            'amount': amountToAdd,
            'type': 'credit', // Assuming loading money adds to the balance
            'timestamp': Timestamp.now(),
          }])
        });

        setState(() {
          receiverBalance = newRBalance;
          senderBalance = newSBalance;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Money loaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        amountController.clear();
        pinController.clear();
      }catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading money. Please try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid transaction PIN.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('E-mail'),
                      const SizedBox(height: 12),
                      UiHelper.customTextField(
                        recipientEmailController,
                        "Please enter the Receiver's E-mail",
                        false,
                        false,
                      ),
                      const SizedBox(height: 12),
                      Visibility(
                        visible: check,
                          child: UiHelper.customButtom(
                                () async {
                              String recipientEmail = recipientEmailController.text;
                              if (recipientEmail.isEmpty) {
                                UiHelper.customAlertbox(context,
                                    "Please enter the recipient's email to check if they exist.");
                                return;
                              }
                              await fetchData(recipientEmail,context);
                            },
                            'Check User',
                          ),
                      ),
                      // SizedBox(height: 12,),
                      Visibility(
                        visible: userExists,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Amount'),
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
                            UiHelper.customButtom(
                                  () async {
                                String recipientEmail = recipientEmailController.text;
                                String amount = amountController.text;
                                String pin = pinController.text;

                                if (recipientEmail.isEmpty || amount.isEmpty || pin.isEmpty) {
                                  UiHelper.customAlertbox(context,
                                      "Please fill all fields: recipient's email, amount, and transaction PIN");
                                  return;
                                }
                                await sendBalance(recipientEmail.toString());
                                // Proceed with the transaction
                              },
                              'Send Amount',
                            ),
                          ],
                        ),
                      ),
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
