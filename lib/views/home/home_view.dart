import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../enums/gametype_enum.dart';
import '../../helper/box_and_text_style.dart';
import '../../helper/box_properties.dart';
import 'home_model.dart';
import 'widgets/action_btns.dart';
import 'widgets/game_type_btns.dart';

class HomeView extends StatelessWidget {
  final double _tableSize = 280.0;
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Puzzle Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.headline4!.fontSize,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => HomeModel.instance(context: context),
          builder: (_, child) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Selector<HomeModel, GameType>(
                  selector: (_, m) => m.gameType,
                  builder: (_, type, __) => GameTypeBtns(tableSize: _tableSize),
                ),
                Center(
                  child: Selector<HomeModel, Tuple2<bool, bool>>(
                    selector: (_, m) => Tuple2(m.showOrderList, m.listChanged),
                    builder: (_, items, __) {
                      return _PuzzleTableWidget(
                        tableSize: _tableSize,
                        list: !items.item1 ? _.read<HomeModel>().shuffeledList : _.read<HomeModel>().orderList,
                      );
                    },
                  ),
                ),
                ActionBtnsWidget(tableSize: _tableSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PuzzleTableWidget extends StatelessWidget {
  const _PuzzleTableWidget({
    Key? key,
    required this.tableSize,
    required this.list,
  }) : super(key: key);

  final double tableSize;
  final List<BoxProperties> list;
  final double spacing = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableSize + (spacing * 8),
      height: tableSize + (spacing * 8),
      alignment: Alignment.center,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        crossAxisCount: 4,
        children: List.generate(
          list.length,
          (index) {
            return _Tile(
              list: list,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    Key? key,
    required this.list,
    required this.index,
  }) : super(key: key);

  final List<BoxProperties> list;
  final int index;

  @override
  Widget build(BuildContext context) {
    BoxProperties box = list[index];
    return context.read<HomeModel>().boxIsMoveable(box: box)
        ? InkWell(
            onTap: () {
              int targetIndex = list.indexWhere((element) => element.isTarget);
              context.read<HomeModel>().move(targetIndex: targetIndex, movedIndex: index);
            },
            child: _BoxContainer(box: box),
          )
        : _BoxContainer(box: box);
  }
}

class _BoxContainer extends StatelessWidget {
  final BoxProperties box;

  const _BoxContainer({Key? key, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.read<HomeModel>().getBoxDecoration(box: box),
      alignment: Alignment.center,
      child: Text(
        context.read<HomeModel>().getBoxText(box: box),
        style: BoxAndTextStyle.textStyle,
      ),
    );
  }
}
