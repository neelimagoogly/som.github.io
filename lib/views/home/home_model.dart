import 'package:flutter/material.dart';

import '../../enums/gametype_enum.dart';
import '../../helper/box_and_text_style.dart';
import '../../helper/box_properties.dart';
import '../../helper/puzzle_list_creator.dart';

class HomeModel extends ChangeNotifier {
  late BuildContext _context;

  late List<BoxProperties> _orderList;
  List<BoxProperties> get orderList => _orderList;
  late List<BoxProperties> _shuffeledList;
  List<BoxProperties> get shuffeledList => _shuffeledList;

  GameType _gameType = GameType.number;
  GameType get gameType => _gameType;

  bool _showOrderList = false;
  bool get showOrderList => _showOrderList;

  bool _listChanged = false;
  bool get listChanged => _listChanged;

  int _moveCount = 0;
  int get moveCount => _moveCount;

  bool _keepGamesState = false;
  bool get keepGamesState => _keepGamesState;

  HomeModel.instance({required BuildContext context}) {
    _context = context;
    _createPuzzleList();
  }

  _createPuzzleList() {
    Map<String, List<BoxProperties>> numberListMap = PuzzleListCreator.instance.getPuzzleList();
    _orderList = numberListMap['orderList'] as List<BoxProperties>; //FOR SHOW SOLUTION
    _shuffeledList = numberListMap['shuffeledList'] as List<BoxProperties>;
    // _printList(_orderList, 'first-created-ordered');
    // debugPrint('\n');
    // _printList(_shuffeledList, 'first-created-shuffled');
  }

  void changeKeepGameState() {
    _keepGamesState = !_keepGamesState;
    notifyListeners();
  }

  bool boxIsMoveable({required BoxProperties box}) {
    int? index = box.shuffleIndex;
    return index - 1 >= 0 && _shuffeledList[index - 1].isTarget && index % 4 != 0 ||
        index + 1 < 16 && _shuffeledList[index + 1].isTarget && (index + 1) % 4 != 0 ||
        (index - 4 >= 0 && _shuffeledList[index - 4].isTarget) ||
        (index + 4 < 16 && _shuffeledList[index + 4].isTarget);
  }

  String getBoxText({required BoxProperties box}) {
    return _gameType == GameType.math
        ? box.mathValue
        : _gameType == GameType.word
            ? box.wordValue
            : box.orderIndex + 1 == 16
                ? ''
                : '${box.orderIndex + 1}';
  }

  BoxDecoration getBoxDecoration({required BoxProperties box}) {
    return BoxAndTextStyle.instance.getBoxDecoration(
      context: _context,
      box: box,
      isRightPosition: isRightPosition(box: box),
    );
  }

  bool isRightPosition({required BoxProperties box}) {
    if (_gameType == GameType.number) {
      return box.shuffleIndex == box.orderIndex;
    }
    if (box.shuffleIndex == box.orderIndex) {
      return true;
    } else {
      int i = _shuffeledList.indexWhere((element) => element.orderIndex == box.shuffleIndex);
      if (i > -1) {
        return _gameType == GameType.math ? _shuffeledList[i].mathValue == box.mathValue : _shuffeledList[i].wordValue == box.wordValue;
      }
      return false;
    }
  }

  void move({required int targetIndex, required int movedIndex}) {
    BoxProperties targetBox = BoxProperties.clone(_shuffeledList[targetIndex]);
    BoxProperties movedBox = BoxProperties.clone(_shuffeledList[movedIndex]);

    _shuffeledList.replaceRange(targetIndex, targetIndex + 1, [movedBox]);
    _shuffeledList.replaceRange(movedIndex, movedIndex + 1, [targetBox]);

    _shuffeledList[movedIndex].shuffleIndex = movedIndex;
    _shuffeledList[targetIndex].shuffleIndex = targetIndex;

    //_printList(_shuffeledList, 'after-moved');
    _listChanged = !_listChanged;
    _moveCount++;
    checkFinished();
    notifyListeners();
  }

  void changeGameType({required GameType type}) {
    _gameType = type;
    if (!_keepGamesState) {
      refreshGame();
    } else {
      _listChanged = !_listChanged;
      notifyListeners();
    }
  }

  void showSolution() {
    _showOrderList = true;
    notifyListeners();
  }

  void continueGame() {
    _showOrderList = false;
    notifyListeners();
  }

  void refreshGame() {
    Map<String, List<BoxProperties>> numberListMap = PuzzleListCreator.instance.getPuzzleList();
    _orderList = numberListMap['orderList'] as List<BoxProperties>; //FOR SHOW SOLUTION
    _shuffeledList = numberListMap['shuffeledList'] as List<BoxProperties>;
    _moveCount = 0;
    _listChanged = !_listChanged;
    _showOrderList = false;
    notifyListeners();
  }

  void checkFinished() {
    bool isFinished = false;
    for (var element in _shuffeledList) {
      bool val = isRightPosition(box: element);
      if (!val) {
        debugPrint('Game is not finished...');
        return;
      } else {
        if (val && element.shuffleIndex == 15) {
          isFinished = true;
        }
      }
    }
    if (isFinished) {
      showDialog<void>(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Congratulations!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('You have solved the puzzle.'),
                  Text('Want to start a new puzzle?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('new puzzle'),
                onPressed: () {
                  Navigator.of(context).pop();
                  refreshGame();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _printList(list, name) {
    for (var e in list) {
      debugPrint(
        '$name: id: ${e.id} wordValue: ${e.wordValue} value: ${e.mathValue} orderIndex: ${e.orderIndex} shuffleIndex: ${e.shuffleIndex} isTarget: ${e.isTarget}',
      );
    }
  }
}
