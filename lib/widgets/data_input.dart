// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';

class Data_input extends StatelessWidget {
  const Data_input({
    super.key,
    required this.onChange,
    required this.question,
    required this.unit,
    required this.reset,
    required this.prevVal,
  });

  final Function(String) onChange;
  final String question;
  final String unit;
  final bool reset;
  final String prevVal;

  @override
  Widget build(BuildContext context) {
    var inputController = TextEditingController();

    if (reset) {
      inputController.clear();
    } else {
      inputController.text = prevVal;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            // weight of the car
            question,
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
                onChanged: onChange,
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
                  hintText: unit,
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
          Icon(
            Icons.arrow_drop_down_sharp,
            color: Colors.black26,
            size: 40.0,
          ),
        ],
      ),
    );
  }
}
