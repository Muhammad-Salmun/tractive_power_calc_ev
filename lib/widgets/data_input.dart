// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names, must_be_immutable
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tractive_power_calc_ev/Pages/home.dart';

class Data_input extends StatefulWidget {
  const Data_input({
    super.key,
    required this.onChange,
    required this.question,
    required this.unit,
    required this.imageName,
    required this.reset,
    required this.prevVal,
  });

  final Function(String) onChange;
  final String question;
  final String unit;
  final String imageName;
  final bool reset;
  final String prevVal;

  @override
  State<Data_input> createState() => _Data_inputState();
}

class _Data_inputState extends State<Data_input> {
  var turn = 0, height = 0.0;
  @override
  Widget build(BuildContext context) {
    final contentWidth = MediaQuery.of(context).size.width;
    final imageHeight = min(contentWidth, 200.0);
    var inputController = TextEditingController();
    if (widget.reset) {
      inputController.clear();
    } else {
      inputController.text = widget.prevVal;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // weight of the car
                widget.question,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  height: 1.2,
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                // Unit kg, in, m ....
                width: 69.0,
                height: 33.0,
                child: Center(
                  child: TextField(
                    onChanged: widget.onChange,
                    controller: inputController,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(15.0)),
                      hintText: widget.unit,
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Transform.rotate(
                angle: pi * turn,
                child: GestureDetector(
                  onTap: () {
                    if (turn == 0) {
                      turn = 1;
                      height = imageHeight;
                      Home.minHeight.value += imageHeight;
                    } else {
                      turn = 0;
                      height = 0;
                      Home.minHeight.value -= imageHeight;
                    }
                  },
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: Colors.black26,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: height,
            child: Image.asset(
              'assets/images/${widget.imageName}.png',
            ),
          )
        ],
      ),
    );
  }
}
