import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enums/gametype_enum.dart';
import '../home_model.dart';

class GameTypeBtns extends StatelessWidget {
  final double tableSize;
  const GameTypeBtns({Key? key, required this.tableSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableSize + 20,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: .5, color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                _Button(
                  gameType: GameType.number,
                  text: '1',
                  subtitle: 'Number',
                ),
                SizedBox(width: 12.0),
                _Button(
                  gameType: GameType.math,
                  text: '=?',
                  subtitle: 'Math',
                ),
                SizedBox(width: 12.0),
                _Button(
                  gameType: GameType.word,
                  text: 'W',
                  subtitle: 'Word',
                ),
              ],
            ),
          ),
          const _MoveBox()
        ],
      ),
    );
  }
}

class _MoveBox extends StatelessWidget {
  const _MoveBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 50.0,
            alignment: Alignment.center,
            child: Text(
              '${context.watch<HomeModel>().moveCount}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headline6!.fontSize,
              ),
            ),
          ),
          Text(
            'Moves',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final GameType gameType;
  final String text;
  final String subtitle;

  const _Button({
    Key? key,
    required this.gameType,
    required this.text,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: context.watch<HomeModel>().gameType == gameType ? Theme.of(context).primaryColor : Colors.blueGrey,
          onPressed: () {
            if (context.read<HomeModel>().gameType != gameType) {
              context.read<HomeModel>().changeGameType(type: gameType);
            }
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.headline6!.fontSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
        )
      ],
    );
  }
}
