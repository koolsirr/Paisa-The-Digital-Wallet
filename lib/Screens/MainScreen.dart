import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isHidden = true;

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
                      colors: [Colors.grey, Colors.greenAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        child: Icon(Iconsax.wallet_money,size: 35),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: SizedBox(
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 40,width: 35,
                                child: Text("Rs.",
                                    style:TextStyle(
                                      fontSize: 25,
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 40,width: 200,
                                child:
                                 isHidden ? const Text(
                                     'xxxxx',
                                   style: TextStyle(
                                     fontSize: 25
                                   ),
                                 ) : const Text(
                                     '1000', //moneyyyy
                                 style: TextStyle(
                                   fontSize: 25
                                 ),),
                                ),
                              SizedBox(
                                width: 50,
                                child: IconButton(
                                  icon: Icon(isHidden ? Iconsax.eye : Iconsax.eye_slash,size: 25,color: Colors.black,),
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
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 151,
                        decoration: BoxDecoration(
                            // color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                              color: Colors.black,
                              width: 2
                        ),
                      ),),
                       const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 151,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: Colors.black,
                            width: 2
                          )
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
                color: Colors.green,
                height: 30,
              ),
            ],
          ),
        )
    );
  }
}
