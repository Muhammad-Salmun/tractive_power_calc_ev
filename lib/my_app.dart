// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tractive_power_calc_ev/Pages/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      home: Home(),
    );
  }
}
