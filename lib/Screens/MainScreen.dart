import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject_paisa/Screens/LoadMoney.dart';
import 'package:majorproject_paisa/Screens/SendMoney.dart';
import 'package:majorproject_paisa/Screens/Statements.dart';
import 'FetchUserData.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String email = FirebaseAuth.instance.currentUser?.email ?? '';
  late DocumentSnapshot userSnapshot;
  int balance = 0;
  bool isHidden = true;
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    UserDataService.onUserDataUpdated = _fetchUserData;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();
    balance = int.parse(userSnapshot['Balance']);
    transactions = userSnapshot['Transactions'] ?? [];

    setState(() {});
  }

  void toggleHidden() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  // color: Colors.grey,
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blueGrey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Icon(Iconsax.wallet_money, size: 35),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: SizedBox(
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 40,
                                width: 35,
                                child: Text("Rs.",
                                    style: TextStyle(
                                      fontSize: 25,
                                    )),
                              ),
                              SizedBox(
                                height: 40,
                                width: 200,
                                child: isHidden
                                    ? const Text(
                                  'xxxxx',
                                  style: TextStyle(fontSize: 25),
                                )
                                    : Text(
                                  '$balance', //moneyyyy
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: IconButton(
                                  icon: Icon(
                                    isHidden ? Iconsax.eye_slash : Iconsax.eye,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  onPressed: toggleHidden,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 90,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoadMoney()));
                        },
                        child: Container(
                          width: 151,
                          decoration: BoxDecoration(
                            // color: Colors.black,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(Iconsax.wallet_add_14, size: 26),
                                // const SizedBox(height: 8.0),
                                Text(
                                  'Load Wallet',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SendMoney()));
                        },
                        child: Container(
                          width: 151,
                          decoration: BoxDecoration(
                            // color: Colors.blue,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                              border:
                              Border.all(color: Colors.black, width: 2)),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(
                                  Iconsax.wallet_minus4,
                                  size: 26,
                                ),
                                // const SizedBox(height: 8.0),
                                Text(
                                  'Send Money',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: 500,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 2)
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Statement',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          var transaction = transactions[index];
                          var amount = transaction['amount'];
                          var type = transaction['type'];
                          return ListTile(
                            leading: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                transaction['type'] == 'credit' ? Colors.green : Colors.red,
                                BlendMode.srcIn,
                              ),
                              child: Icon(
                                transaction['type'] == 'credit' ? Icons.add_circle : Icons.remove_circle,
                              ),
                            ),
                            title: Text(type == 'credit' ? 'Rs. $amount' : 'Rs. $amount'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
