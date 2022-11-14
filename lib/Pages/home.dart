import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/data_input.dart';
import '../widgets/data_output.dart';
import '../data/data_def.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static ValueNotifier<double> minHeight = ValueNotifier(800.0);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool reset = false;

  bool isEmpty(param) {
    if (param.value == '') {
      _showMyDialog(context, message: '${param.question} cannot be empty');
      return true;
    } else {
      return false;
    }
  }

  bool isZero(param) {
    if (double.parse(param.value) == 0) {
      _showMyDialog(context, message: '${param.question} cannot be zero');
      return true;
    } else {
      return false;
    }
  }

  //calculating values
  void calculate() {
    // make sure no values are empty
    if (isEmpty(carWeight) |
        isEmpty(tireDia) |
        isEmpty(frontalArea) |
        isEmpty(dragSpeed) |
        isEmpty(timeTaken) |
        isEmpty(crr) |
        isEmpty(cd)) return;
    var velocity = double.parse(dragSpeed.value);
    //velocity is dragSpeed in m.s
    velocity = velocity * 0.277777778;
    // makes sure time taken is not zero
    if (isEmpty(timeTaken) | isZero(timeTaken)) return;
    maxAcceleration.value = (velocity / double.parse(timeTaken.value));
    //refer equation of total tractive power(p4 is total force)
    var p1 = double.parse(crr.value) * double.parse(carWeight.value) * 9.81;
    // p2 cannot be zero
    if (isZero(cd) | isZero(frontalArea)) return;
    var p2 = 0.6125 * double.parse(cd.value) * double.parse(frontalArea.value);
    var totalForceForAcceleration =
        maxAcceleration.value * double.parse(carWeight.value);
    var p4 = p1 + (p2 * velocity * velocity) + totalForceForAcceleration;
    //starting torque is force times tire dia
    startingTorque.value = p4 * double.parse(tireDia.value) * 0.0127;
    totalTractivePower.value = p4 * velocity;
    //solving cubic equation to obtain top speed
    var p = p1 / p2;
    var q = totalTractivePower.value / p2; //minus sign cancels out later
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

    topSpeed.value = topVelocity * 3.6;
    topSpeedTorque.value = p5 * double.parse(tireDia.value) * 0.0127;
    // tire dia cannot be zero
    if (isZero(tireDia)) return;
    maxRPMatWheel.value =
        (topVelocity * 60) / (double.parse(tireDia.value) * 0.0254 * 3.14);
    setState(() {});
  }

  // reset button action
  resetValues() {
    reset = true;
    carWeight.value = '';
    tireDia.value = '';
    frontalArea.value = '';
    dragSpeed.value = '';
    timeTaken.value = '';
    crr.value = '';
    cd.value = '';
    maxAcceleration.value = 0.0;
    startingTorque.value = 0.0;
    totalTractivePower.value = 0.0;
    topSpeed.value = 0.0;
    topSpeedTorque.value = 0.0;
    maxRPMatWheel.value = 0.0;
    setState(() {});
    //  runs only after set state is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reset = false;
    });
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
              question: carWeight.question,
              unit: carWeight.unit,
              onChange: (value) {
                carWeight.value = value;
              },
              reset: reset,
              prevVal: carWeight.value,
              imageName: carWeight.img,
            ),
            Data_input(
              question: tireDia.question,
              unit: tireDia.unit,
              onChange: (value) {
                tireDia.value = value;
              },
              reset: reset,
              prevVal: tireDia.value,
              imageName: tireDia.img,
            ),
            Data_input(
              question: frontalArea.question,
              unit: frontalArea.unit,
              onChange: (String value) {
                frontalArea.value = value;
              },
              reset: reset,
              prevVal: frontalArea.value,
              imageName: frontalArea.img,
            ),
            Data_input(
              question: dragSpeed.question,
              unit: dragSpeed.unit,
              onChange: (String value) {
                dragSpeed.value = value;
              },
              reset: reset,
              prevVal: dragSpeed.value,
              imageName: dragSpeed.img,
            ),
            Data_input(
              question: timeTaken.question,
              unit: timeTaken.unit,
              onChange: (String value) {
                timeTaken.value = value;
              },
              reset: reset,
              prevVal: timeTaken.value,
              imageName: timeTaken.img,
            ),
            Data_input(
              question: crr.question,
              unit: crr.unit,
              onChange: (String value) {
                crr.value = value;
              },
              reset: reset,
              prevVal: crr.value,
              imageName: crr.img,
            ),
            Data_input(
              question: cd.question,
              unit: cd.unit,
              onChange: (String value) {
                cd.value = value;
              },
              reset: reset,
              prevVal: cd.value,
              imageName: cd.img,
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
                outputParam: maxAcceleration.outputParam,
                outputVal: maxAcceleration.value.toStringAsFixed(2),
                outputValUnit: maxAcceleration.unit,
              ),
              Data_output(
                  outputParam: totalTractivePower.outputParam,
                  outputVal: totalTractivePower.value.toStringAsFixed(2),
                  outputValUnit: 'W'),
              Data_output(
                  outputParam: 'Starting torque',
                  outputVal: startingTorque.value.toStringAsFixed(2),
                  outputValUnit: 'Nm'),
              Data_output(
                  outputParam: 'Top speed of the car',
                  outputVal: topSpeed.value.toStringAsFixed(2),
                  outputValUnit: 'kmph'),
              Data_output(
                  outputParam: 'Torque to maintain top speed',
                  outputVal: topSpeedTorque.value.toStringAsFixed(2),
                  outputValUnit: 'Nm'),
              Data_output(
                  outputParam: 'Max RPM at wheel',
                  outputVal: maxRPMatWheel.value.toStringAsFixed(2),
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

Future<void> _showMyDialog(context, {required String message}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'ERROR!!',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
