import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:majorproject_paisa/Screens/Banks.dart';
import 'FetchUserData.dart';
import 'UiHelper.dart';

class LoadMoney extends StatefulWidget {
  const LoadMoney({Key? key}) : super(key: key);

  @override
  State<LoadMoney> createState() => _LoadMoneyState();
}

class _LoadMoneyState extends State<LoadMoney> {
  String? userEmail;
  String? userPin;
  num? userBalance;
  String? balanceString;

  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call the function during initialization
  }

  Future<void> _fetchUserData() async {
    userEmail = await UserDataService.fetchUserData('Email');
    balanceString = await UserDataService.fetchUserData('Balance');
    userBalance = int.tryParse(balanceString!);
    userPin = await UserDataService.fetchUserData('Transaction Pin');
    setState(() {});
  }

  Future<void> loadWallet() async {
    if (pinController.text.isEmpty || amountController.text.isEmpty) {
      UiHelper.customAlertbox(
          context, "Please fill all fields: amount and transaction PIN");
      return;
    }

    if (userEmail == null || userEmail!.isEmpty) {
      UiHelper.customAlertbox(context, "User email not found");
      return;
    }

    if (pinController.text == userPin) {
      num amountToAdd = int.tryParse(amountController.text) as num;
      num newBalance = (userBalance)! + amountToAdd;

      String newBalanceString = newBalance.toString();

      try {
        User? user = FirebaseAuth.instance.currentUser;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: user?.email)
            .get();

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userEmail)
              .update({
            'Balance': newBalanceString,
            'Transactions': FieldValue.arrayUnion([{
              'amount': amountToAdd,
              'type': 'credit', // Assuming loading money adds to the balance
              'timestamp': Timestamp.now(),
            }])
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
                      Text('$userEmail,$userBalance'),
                      Text(
                        'Amount',
                        style: Theme.of(context).textTheme.titleMedium,
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
                        style: Theme.of(context).textTheme.titleMedium,
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
