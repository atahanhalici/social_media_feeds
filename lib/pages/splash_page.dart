import 'dart:async';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
@override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
       Navigator.pushNamedAndRemoveUntil(
                                      context, "/login", (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
       const   Expanded(child: SizedBox()),
          Center(
            child: Image.asset("assets/logo.png",width: MediaQuery.of(context).size.width*0.75,) 
          ),const Expanded(child: SizedBox()),
       const   Text("Made by Atahan HALICI", style: TextStyle(color: Colors.black54),),
       const   SizedBox(height: 10,)
        ],
      ),
    );
  }
}