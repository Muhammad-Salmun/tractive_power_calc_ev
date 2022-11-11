import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/data_input.dart';
import '../widgets/data_output.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static ValueNotifier<double> minHeight = ValueNotifier(800.0);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool reset = false;
  var carWeight = '',
      tireDia = '',
      frontalArea = '',
      dragSpeed = '',
      timeTaken = '',
      crr = '',
      cd = '',
      maxAcceleration = 0.0,
      startingTorque = 0.0,
      totalTractivePower = 0.0,
      topSpeed = 0.0,
      topSpeedTorque = 0.0,
      maxRPMatWheel = 0.0;

  //calculating values
  void calculate() {
    //velocity is dragSpeed in m.s
    var velocity = double.parse(dragSpeed);
    velocity = velocity * 0.277777778;
    maxAcceleration = (velocity / double.parse(timeTaken));
    //refer equation of total tractive power(p4 is total force)
    var p1 = double.parse(crr) * double.parse(carWeight) * 9.81;
    var p2 = 0.6125 * double.parse(cd) * double.parse(frontalArea);
    var totalForceForAcceleration = maxAcceleration * double.parse(carWeight);
    var p4 = p1 + (p2 * velocity * velocity) + totalForceForAcceleration;
    //starting torque is force times tire dia
    startingTorque = p4 * double.parse(tireDia) * 0.0127;
    totalTractivePower = p4 * velocity;
    //solving cubic equation to obtain top speed
    var p = p1 / p2;
    var q = totalTractivePower / p2; //minus sign cancels out later
    var P = p / 3;
    var Q = q / 2;
    var discriminant = pow(Q, 2) + pow(P, 3);
    //topVelocity is topSpeed in m/s2
    var discriminantRoot = pow(discriminant, 0.5);
    var t1 = Q + discriminantRoot;
    var t2 = Q - discriminantRoot;
    t1 = cbrt(t1);
    t2 = cbrt(t2);
    var topVelocity = (t1 + t2).toDouble();
    var p5 = p1 + (p2 * pow(topVelocity, 2));

    topSpeed = topVelocity * 3.6;
    topSpeedTorque = p5 * double.parse(tireDia) * 0.0127;
    maxRPMatWheel =
        (topVelocity * 60) / (double.parse(tireDia) * 0.0254 * 3.14);

    setState(() {});
  }

  // reset button action
  void resetValues() {
    reset = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // calcualting screen height after removing status bar height
    final screenHeigth = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return appContainer(screenHeigth);
            },
            valueListenable: Home.minHeight,
          ),
        ),
      ),
    );
  }

  ConstrainedBox appContainer(double screenHeigth) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: max(Home.minHeight.value, screenHeigth),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          inputFrame(0, reset),
          controlBtn(),
          outputFrame(0),
        ],
      ),
    );
  }

  Expanded inputFrame(flexVal, reset) {
    return Expanded(
      flex: flexVal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Input Parameters',
              style: TextStyle(
                color: Color.fromRGBO(17, 11, 85, 1),
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            const Text(
              'Fill in required info',
              style: TextStyle(
                color: Color.fromRGBO(17, 11, 85, 1),
                fontSize: 13.0,
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Data_input(
              question: 'Weight of the car',
              unit: 'Kg',
              onChange: (value) {
                carWeight = value;
              },
              reset: reset,
              prevVal: carWeight,
              imageName: 'car_weight',
            ),
            Data_input(
              question: 'Tire diameter',
              unit: 'in',
              onChange: (value) {
                tireDia = value;
              },
              reset: reset,
              prevVal: tireDia,
              imageName: 'tire_dia',
            ),
            Data_input(
              question: 'Frontal area of car',
              unit: 'm',
              onChange: (String value) {
                frontalArea = value;
              },
              reset: reset,
              prevVal: frontalArea,
              imageName: 'frontal_area',
            ),
            Data_input(
              question: 'Maximum speed of car',
              unit: 'kmph',
              onChange: (String value) {
                dragSpeed = value;
              },
              reset: reset,
              prevVal: dragSpeed,
              imageName: 'max_speed',
            ),
            Data_input(
              question: 'Top speed achieving time',
              unit: 'sec',
              onChange: (String value) {
                timeTaken = value;
              },
              reset: reset,
              prevVal: timeTaken,
              imageName: 'top_time',
            ),
            Data_input(
              question: 'Coefficint of rolling resistance',
              unit: '',
              onChange: (String value) {
                crr = value;
              },
              reset: reset,
              prevVal: crr,
              imageName: 'crr',
            ),
            Data_input(
              question: 'Coefficient of air drag',
              unit: '',
              onChange: (String value) {
                cd = value;
              },
              reset: reset,
              prevVal: cd,
              imageName: 'cd',
            ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Padding controlBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: resetValues,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(131, 36),
              side: const BorderSide(
                color: Color.fromRGBO(219, 116, 21, 1),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: const Text(
              'RESET',
              style: TextStyle(
                  color: Color.fromRGBO(219, 116, 21, 1),
                  fontSize: 13.0,
                  height: 1.2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(219, 116, 21, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
            ),
            child: const Text(
              'SUBMIT',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  height: 1.2,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Expanded outputFrame(flexVal) {
    return Expanded(
      flex: flexVal,
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(17, 11, 85, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Output parameters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Data_output(
                outputParam: 'Maximum accelration',
                outputVal: maxAcceleration.toStringAsFixed(2),
                outputValUnit: 'm/s',
              ),
              Data_output(
                  outputParam: 'Total tractive power',
                  outputVal: totalTractivePower.toStringAsFixed(2),
                  outputValUnit: 'W'),
              Data_output(
                  outputParam: 'Starting torque',
                  outputVal: startingTorque.toStringAsFixed(2),
                  outputValUnit: 'Nm'),
              Data_output(
                  outputParam: 'Top speed of the car',
                  outputVal: topSpeed.toStringAsFixed(2),
                  outputValUnit: 'kmph'),
              Data_output(
                  outputParam: 'Torque to maintain top speed',
                  outputVal: topSpeedTorque.toStringAsFixed(2),
                  outputValUnit: 'Nm'),
              Data_output(
                  outputParam: 'Max RPM at wheel',
                  outputVal: maxRPMatWheel.toStringAsFixed(2),
                  outputValUnit: 'rpm'),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(17, 11, 85, 1),
                  minimumSize: const Size.fromHeight(45.0),
                  side: const BorderSide(
                    color: Color.fromRGBO(219, 116, 21, 1),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: const Text(
                  'PRINT REPORT',
                  style: TextStyle(
                      color: Color.fromRGBO(219, 116, 21, 1),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double cbrt(double value) {
  num result = 0.0;
  if (value > 0.0) {
    result = pow(value, 1 / 3);
  } else {
    result = 0 - value;
    result = pow(result, 1 / 3);
    result = 0 - result;
  }
  return result as double;
}
