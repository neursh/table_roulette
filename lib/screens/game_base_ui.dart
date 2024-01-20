import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_roulette/providers/game.dart';
import '../components/player_display.dart';

class GameBaseUI extends StatefulWidget {
  const GameBaseUI({super.key});

  @override
  State<StatefulWidget> createState() => _GameBaseUIState();
}

class _GameBaseUIState extends State<GameBaseUI> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => GameProvider(),
        builder: (context, _) => Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const PlayerFrame(
                        color: Colors.blue, playerSide: PlayerSide.blue)),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const PlayerFrame(
                        color: Colors.red, playerSide: PlayerSide.red))
              ])
            ])));
  }
}
