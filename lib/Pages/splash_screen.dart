import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tractive_power_calc_ev/Pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(17, 11, 85, 1),
      ),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 130,
            child: Image.asset(
              'assets/images/splash_image.png',
            ),
          ),
        ),
      ),
    );
  }
}
