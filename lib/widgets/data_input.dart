import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tractive_power_calc_ev/Pages/home.dart';

class DataInput extends StatefulWidget {
  const DataInput({
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
  State<DataInput> createState() => _DataInputState();
}

class _DataInputState extends State<DataInput> with TickerProviderStateMixin {
  var _rotate = 0.0, _dropdown = 0;
  var imageHeight = 200.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future _toggleContainer() async {
    if (_dropdown == 0) {
      _dropdown = 1;
      _controller.forward();
      _rotate -= 1.0 / 2.0;
      Home.minHeight.value += imageHeight;
    } else {
      _dropdown = 0;
      _rotate += 1.0 / 2.0;
      _controller.animateBack(0,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 400));
      Home.minHeight.value -= imageHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputController = TextEditingController();
    if (!widget.reset) {
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
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                  height: 1.2,
                ),
              ),
              const Expanded(child: SizedBox()),
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
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(15.0)),
                      hintText: widget.unit,
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              // drop down arrow
              const SizedBox(width: 8.0),
              AnimatedRotation(
                turns: _rotate,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: () {
                    _toggleContainer();
                  },
                  child: const Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: Colors.black26,
                  ),
                ),
              )
            ],
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: SizedBox(
              height: 200,
              child: Image.asset(
                'assets/images/${widget.imageName}.png',
              ),
            ),
          )
        ],
      ),
    );
  }
}
