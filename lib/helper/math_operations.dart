import 'package:function_tree/function_tree.dart';

import '../enums/operators_enum.dart';
import 'box_properties.dart';

class MathOperations {
  static MathOperations? _instance;
  static MathOperations get instance {
    return _instance ??= MathOperations._init();
  }

  MathOperations._init();

  String getSymbol({required Operators operator}) {
    switch (operator) {
      case Operators.plus:
        return '+';
      case Operators.minus:
        return '-';
      case Operators.multiple:
        return '*';
      case Operators.equals:
        return '=';
    }
  }

  String getOperationResult({
    required List<BoxProperties> list,
    required int index,
  }) {
    String op = getSymbol(operator: Operators.equals);
    /* 
      Find first value of column
      If first value operator is '*', interpret() function doesn' t work as expected.
      Just get the number.
    */
    var split = list[index - 3].mathValue.split(' ');
    String str = split[0] == '*' ? split[1] : list[index - 3].mathValue;
    /*
      Start the loop from the second element of column,
      Because the first element has already been selected above.
    */
    for (int j = index - 2; j < index; j++) {
      str += ' ${list[j].mathValue}';
    }
    return '$op ${str.interpret().toInt()}';
  }
}
