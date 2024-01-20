import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../components/border.dart';
import '../components/scene_button.dart';
import '../providers/game.dart';

enum PlayerSide { blue, red }

class PlayerFrame extends StatefulWidget {
  final Color color;
  final PlayerSide playerSide;
  const PlayerFrame({super.key, required this.color, required this.playerSide});

  @override
  State<StatefulWidget> createState() => _PlayerFrameState();
}

class _PlayerFrameState extends State<PlayerFrame> {
  ValueNotifier<bool> useItem = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
        builder: (context, gameProvider, _) => Stack(children: [
              TurnHighlight(
                  active:
                      gameProvider.currentTurn.name == widget.playerSide.name,
                  color: widget.color),
              OutlineDecorate(color: widget.color),
              Align(
                  alignment: widget.playerSide == PlayerSide.blue
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Transform.rotate(
                      angle: widget.playerSide == PlayerSide.blue
                          ? math.pi / 2
                          : -math.pi / 2,
                      child: HealthIndicator(
                          currentHealth:
                              gameProvider.healthInfo[widget.playerSide.name]!,
                          color: widget.color))),
              Align(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                      angle: widget.playerSide == PlayerSide.blue ? 0 : math.pi,
                      child: gameProvider.currentTurn.name ==
                              widget.playerSide.name
                          ? ShootAction(
                              onSelfShoot: gameProvider.selfShoot,
                              onShootOpponent: gameProvider.shootOpponent)
                          : null)),
              gameProvider.currentTurn.name == widget.playerSide.name
                  ? Align(
                      alignment: widget.playerSide == PlayerSide.blue
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Transform.rotate(
                          angle: widget.playerSide == PlayerSide.blue
                              ? math.pi / 2
                              : -math.pi / 2,
                          child: Inventory(
                              color: widget.color,
                              side: widget.playerSide.name)))
                  : Container(),
              gameProvider.roundIntro
                  ? AbsorbPointer(
                      child: SizedBox(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          child: Align(
                              alignment: widget.playerSide == PlayerSide.blue
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Transform.rotate(
                                  angle: widget.playerSide == PlayerSide.blue
                                      ? math.pi / 2
                                      : -math.pi / 2,
                                  child: SceneButton(
                                    color: Colors.green,
                                    width: 200,
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                      "${gameProvider.lives} lives, ${gameProvider.blanks} blanks.",
                                      style: const TextStyle(
                                          fontFamily: "Arcade", fontSize: 16),
                                    )),
                                  ))).animate(delay: 3.seconds).fadeOut()))
                  : Container(),
              gameProvider.winner.isNotEmpty
                  ? Container(
                      color: Colors.black.withOpacity(.7),
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Transform.rotate(
                          angle: widget.playerSide == PlayerSide.blue
                              ? math.pi / 2
                              : -math.pi / 2,
                          child: SceneButton(
                            color: Colors.green,
                            width: 300,
                            height: 80,
                            child: Center(
                                child: Text(
                                    "${gameProvider.winner.toUpperCase()} wins!",
                                    style: const TextStyle(
                                        fontFamily: "Arcade", fontSize: 32))),
                          )))
                  : Container()
            ]));
  }
}

class ShootAction extends StatelessWidget {
  final void Function() onSelfShoot;
  final void Function() onShootOpponent;
  const ShootAction(
      {super.key, required this.onSelfShoot, required this.onShootOpponent});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          height: 100,
          child: Dismissible(
              onDismissed: (_) => onSelfShoot(),
              direction: DismissDirection.endToStart,
              key: UniqueKey(),
              child: const Icon(Icons.arrow_back, size: 100))),
      const SizedBox(height: 50),
      SizedBox(
          height: 100,
          child: Dismissible(
              onDismissed: (_) => onShootOpponent(),
              direction: DismissDirection.startToEnd,
              key: UniqueKey(),
              child: const Icon(Icons.arrow_forward, size: 100)))
    ]);
  }
}

class HealthIndicator extends StatelessWidget {
  final Color color;
  final int currentHealth;
  const HealthIndicator(
      {super.key, required this.color, required this.currentHealth});

  @override
  Widget build(BuildContext context) {
    return SceneButton(
        color: color,
        width: 150,
        height: 40,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < currentHealth; i++)
                const Icon(Icons.bolt_sharp)
                    .animate(delay: (.5 + .1 * i).seconds)
                    .fadeIn()
                    .moveX(begin: 10, end: 0, curve: Curves.ease)
            ]));
  }
}

class Inventory extends StatefulWidget {
  final Color color;
  final String side;
  const Inventory({super.key, required this.color, required this.side});

  @override
  State<StatefulWidget> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  bool isOpened = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => !isOpened ? setState(() => isOpened = true) : null,
        child: AnimatedContainer(
            duration: .25.seconds,
            curve: Curves.ease,
            width: isOpened ? 300 : 130,
            height: isOpened ? 150 : 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: widget.color.withOpacity(.5),
            child: Consumer<GameProvider>(
                builder: (context, gameProvider, _) => isOpened
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Wrap(spacing: 15, runSpacing: 15, children: [
                              for (String item
                                  in gameProvider.inventory[widget.side]!)
                                GestureDetector(
                                    onTap: () {
                                      gameProvider.inventory[widget.side]!
                                          .remove(item);
                                      gameProvider.activateItem[item]();
                                    },
                                    child: Text(item,
                                        style: const TextStyle(
                                            fontFamily: "Arcade",
                                            fontSize: 20)))
                            ]),
                            IconButton(
                                onPressed: () =>
                                    setState(() => isOpened = false),
                                icon: const Icon(Icons.expand_more))
                          ])
                    : const Center(
                        child: Text("inventory",
                            style: TextStyle(
                                fontFamily: "Arcade", fontSize: 20))))));
  }
}

class TurnHighlight extends StatelessWidget {
  final bool active;
  final Color color;
  const TurnHighlight({super.key, required this.active, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: double.maxFinite,
        width: double.maxFinite,
        color: color.withOpacity(active ? .1 : 0),
        duration: .25.seconds);
  }
}

class OutlineDecorate extends StatelessWidget {
  final Color color;
  const OutlineDecorate({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BorderShape(color: color, height: 50, width: 50, angle: math.pi / 2),
      Align(
          alignment: Alignment.topRight,
          child: BorderShape(
              color: color, height: 50, width: 50, angle: -math.pi)),
      Align(
          alignment: Alignment.bottomLeft,
          child: BorderShape(color: color, height: 50, width: 50)),
      Align(
          alignment: Alignment.bottomRight,
          child: BorderShape(
              color: color, height: 50, width: 50, angle: -math.pi / 2)),
    ]);
  }
}
