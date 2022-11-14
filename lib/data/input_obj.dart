class InputData {
  final String question;
  final String unit;
  final String img;
  String value;

  InputData({
    required this.question,
    required this.unit,
    required this.img,
    required this.value,
  });
}

class OutputData {
  final String outputParam;
  final String unit;
  double value;

  OutputData({
    required this.outputParam,
    required this.unit,
    required this.value,
  });
}
