import 'input_obj.dart';

var carWeight = InputData(
  question: 'Weight of the car',
  unit: 'Kg',
  img: 'car_weight',
  value: '',
);

var tireDia = InputData(
  question: 'Tire diameter',
  unit: 'in',
  img: 'tire_dia',
  value: '',
);

var frontalArea = InputData(
  question: 'Frontal area of car',
  unit: 'm²',
  img: 'frontal_area',
  value: '',
);

var dragSpeed = InputData(
  question: 'Maximum speed of the car',
  unit: 'kmph',
  img: 'max_speed',
  value: '',
);

var timeTaken = InputData(
  question: 'Time taken to acheive top speed',
  unit: 'sec',
  img: 'top_time',
  value: '',
);

var crr = InputData(
  question: 'Coefficient of roling resistance',
  unit: '',
  img: 'crr',
  value: '',
);

var cd = InputData(
  question: 'Coefficient of air drag',
  unit: '',
  img: 'cd',
  value: '',
);

var maxAcceleration = OutputData(
  outputParam: 'Maximum accelration',
  unit: 'm/s',
  value: 0.0,
);

var totalTractivePower = OutputData(
  outputParam: 'Total tractive power',
  unit: 'W',
  value: 0.0,
);

var startingTorque = OutputData(
  outputParam: 'Starting torque',
  unit: 'Nm',
  value: 0.0,
);

var topSpeed = OutputData(
  outputParam: 'Top speed of the car',
  unit: 'kpmh',
  value: 0.0,
);

var topSpeedTorque = OutputData(
  outputParam: 'Torque required to maintain top speed',
  unit: 'Nm',
  value: 0.0,
);

var maxRPMatWheel = OutputData(
  outputParam: 'Maximum RPM at wheel',
  unit: 'rpm',
  value: 0.0,
);
