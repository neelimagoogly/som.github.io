import 'dart:math';

import 'package:flutter/material.dart';

import '../enums/operators_enum.dart';
import 'box_properties.dart';
import 'constants.dart';
import 'math_operations.dart';

class PuzzleListCreator {
  static PuzzleListCreator? _instance;
  static PuzzleListCreator get instance {
    return _instance ??= PuzzleListCreator._init();
  }

  PuzzleListCreator._init();

  Map<String, List<BoxProperties>> getPuzzleList() {
    List<BoxProperties> _list = <BoxProperties>[];
    String _words = _getDummyWordsString();
    var splt = _words.split('');
    for (int i = 0; i < 16; i++) {
      String letter = splt[i];
      bool isTarget = i == 15;
      BoxProperties props;
      if (i == 3 || i == 7 || i == 11 || i == 15) {
        props = _getPropsWithMathResult(index: i, list: _list, letter: letter, isTarget: isTarget);
      } else {
        props = _getProps(index: i, letter: letter);
      }
      _list.add(props);
    }
    List<BoxProperties> _shuffeledList = _getShuffledList(list: _list);
    return {'orderList': _list, 'shuffeledList': _shuffeledList};
  }

  List<BoxProperties> _getShuffledList({required List<BoxProperties> list}) {
    List<BoxProperties> _shuffeledList = list.map((item) => BoxProperties.clone(item)).toList();
    bool isSolvable = false;
    while (!isSolvable) {
      _shuffeledList.shuffle();
      isSolvable = _testSolvable(suffledList: _shuffeledList);
      debugPrint('IS SOLVABLE: $isSolvable');
    }
    for (int i = 0; i < _shuffeledList.length; i++) {
      _shuffeledList[i].shuffleIndex = i;
    }
    return _shuffeledList;
  }

  BoxProperties _getPropsWithMathResult({
    required int index,
    required List<BoxProperties> list,
    required String letter,
    bool isTarget = false,
  }) {
    String mathValue = MathOperations.instance.getOperationResult(
      index: index,
      list: list,
    );
    return BoxProperties(
      id: 'id_$index',
      orderIndex: index,
      shuffleIndex: index,
      mathValue: mathValue,
      wordValue: letter,
      isTarget: isTarget,
    );
  }

  BoxProperties _getProps({
    required int index,
    required String letter,
  }) {
    final List<Operators> _operators = [
      Operators.plus,
      Operators.minus,
      Operators.multiple,
    ];
    final List<int> _numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    Operators randomOperator = _operators[Random().nextInt(_operators.length)];
    int randNumber = _numbers[Random().nextInt(_numbers.length)];
    String op = MathOperations.instance.getSymbol(operator: randomOperator);
    return BoxProperties(
      id: 'id_$index',
      orderIndex: index,
      shuffleIndex: index,
      mathValue: '$op $randNumber',
      wordValue: letter,
      isTarget: false,
    );
  }

  String _getDummyWordsString() {
    List<String> _words = Constants.dummyWords;
    List<String> _list = <String>[];
    String wordsString = '';
    for (int i = 0; i < 4; i++) {
      bool isExist = true;
      while (isExist) {
        String word = _words[Random().nextInt(_words.length - 1)];
        isExist = _list.contains(word);
        if (!isExist) {
          _list.add(word);
          wordsString += word;
        }
      }
    }
    //debugPrint('WORDS STR: $wordsString');
    return wordsString;
  }

  bool _testSolvable({required List<BoxProperties> suffledList}) {
    return _isSolvable(arr: suffledList);
  }

  int _getInvCount({required List<BoxProperties> arr}) {
    int invCount = 0;
    for (int i = 0; i < 4 * 4 - 1; i++) {
      for (int j = i + 1; j < 4 * 4; j++) {
        if (arr[j].orderIndex != 15 && arr[i].orderIndex != 15 && arr[i].orderIndex > arr[j].orderIndex) {
          invCount++;
        }
      }
    }
    return invCount;
  }

  int? _findXPosition({required List<List<BoxProperties>> matrix}) {
    // start from bottom-right corner of matrix
    for (int i = 4 - 1; i >= 0; i--) {
      for (int j = 4 - 1; j >= 0; j--) {
        if (matrix[i][j].isTarget) {
          return 4 - i;
        }
      }
    }
    return null;
  }

  bool _isSolvable({required List<BoxProperties> arr}) {
    int invCount = _getInvCount(arr: arr);
    //debugPrint('INVERSION COUNT: $invCount');
    int? pos = _findXPosition(matrix: _getMatrix(arr: arr));
    //debugPrint('EMPTY BOX POSITION: $pos');
    if (pos != null) {
      if (pos % 2 == 0) {
        //position is even => invCount shold be odd.
        return !(invCount % 2 == 0);
      } else {
        //position is odd => invCount shold be even.
        return invCount % 2 == 0;
      }
    } else {
      return false;
    }
  }

  List<List<BoxProperties>> _getMatrix({required List<BoxProperties> arr}) {
    List<BoxProperties> _column1 = arr.sublist(0, 4);
    List<BoxProperties> _column2 = arr.sublist(4, 8);
    List<BoxProperties> _column3 = arr.sublist(8, 12);
    List<BoxProperties> _column4 = arr.sublist(12, 16);
    List<List<BoxProperties>> _matrix = <List<BoxProperties>>[];
    _matrix.add(_column1);
    _matrix.add(_column2);
    _matrix.add(_column3);
    _matrix.add(_column4);
    return _matrix;
  }
}
