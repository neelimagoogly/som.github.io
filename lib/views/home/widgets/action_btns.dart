import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_model.dart';
import 'info_widget.dart';

class ActionBtnsWidget extends StatelessWidget {
  final double tableSize;
  const ActionBtnsWidget({
    Key? key,
    required this.tableSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableSize + 20,
      decoration: const BoxDecoration(border: Border(top: BorderSide(width: .5, color: Colors.grey))),
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Button(
            icon: Icons.info,
            subtitle: 'Info',
            backgroundColor: Colors.deepPurple,
            onClick: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return const InfoWidget();
                },
              );
            },
          ),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Row(
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'To show solution, long press the button.',
                        style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                      ),
                    )
                  ],
                ),
              ),
            ),
            onLongPressStart: (_) => context.read<HomeModel>().showSolution(),
            onLongPressEnd: (_) => context.read<HomeModel>().continueGame(),
            child: const _Button(
              icon: Icons.lightbulb,
              subtitle: 'Solution',
              backgroundColor: Colors.green,
              onClick: null,
            ),
          ),
          Selector<HomeModel, bool>(
            selector: (_, m) => m.keepGamesState,
            builder: (_, val, __) => _Button(
              icon: val ? Icons.check : Icons.save,
              subtitle: 'Keep',
              backgroundColor: val ? Colors.green : Colors.blueGrey,
              onClick: () {
                context.read<HomeModel>().changeKeepGameState();
              },
            ),
          ),
          _Button(
            icon: Icons.refresh,
            subtitle: 'Refresh',
            backgroundColor: Colors.black,
            onClick: () {
              context.read<HomeModel>().refreshGame();
            },
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback? onClick;

  const _Button({
    Key? key,
    required this.icon,
    required this.subtitle,
    required this.backgroundColor,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: backgroundColor,
          onPressed: onClick,
          child: Icon(
            icon,
            color: Colors.white70,
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
