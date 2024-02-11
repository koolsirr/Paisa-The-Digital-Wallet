import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/Banks.dart';
import 'FetchUserData.dart';
import 'UiHelper.dart';

class LoadMoney extends StatefulWidget {
  const LoadMoney({super.key});

  @override
  State<LoadMoney> createState() => _LoadMoneyState();
}

class _LoadMoneyState extends State<LoadMoney> {
  String? userEmail;
  String? userPin;
  num? userBalance;

  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function during initialization
  }

  Future<void> _fetchUserData() async {
    userEmail = await UserDataService.fetchUserData('Email');
    String? balanceString = await UserDataService.fetchUserData('Balance');
    userBalance = int.tryParse(balanceString ?? '0');
    userPin = await UserDataService.fetchUserData('Transaction Pin');
    setState(() {});
  }

  Future<void> loadWallet() async {
    if (pinController.text.isEmpty || amountController.text.isEmpty) {
      UiHelper.customAlertbox(
          context, "Please fill all fields: amount and transaction PIN");
      return;
    }

    if (pinController.text == userPin) {
      num amountToAdd = int.tryParse(amountController.text) ?? 0;
      num newBalance = (userBalance ?? 0) + amountToAdd;

      String newBalanceString = newBalance.toString();

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({
          'Balance': newBalanceString,
        });

        setState(() {
          userBalance = newBalance;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Money loaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        amountController.clear();
        pinController.clear();
      } catch (e) {
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
        title: const Text('Load Wallet', style: TextStyle(color: Colors.black)),
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        await loadWallet();
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
