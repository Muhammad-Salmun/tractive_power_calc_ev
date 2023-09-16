// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';

class Data_output extends StatelessWidget {
  final String outputParam;
  final String outputVal;
  final String outputValUnit;

  const Data_output({
    Key? key,
    required this.outputParam,
    required this.outputVal,
    required this.outputValUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 178.0,
            child: Text(
              outputParam,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w100),
            ),
          ),
          Expanded(child: SizedBox()),
          SizedBox(
            width: 90.0,
            child: Text(
              outputVal,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              outputValUnit,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
