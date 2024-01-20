import 'package:flutter/material.dart';
import 'package:table_roulette/components/scene_button.dart';
import 'package:table_roulette/screens/game_base_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          "TABLE ROULETTE",
          style: TextStyle(fontSize: 36, fontFamily: "Arcade", wordSpacing: 5),
        ),
        const Text(
          "da roulette game if you wanna live and also doesn't own a gun.",
          style: TextStyle(fontFamily: "Arcade", wordSpacing: 5),
        ),
        const SizedBox(height: 20),
        SceneButton(
          color: Colors.red,
          height: 40,
          width: 120,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GameBaseUI()),
          ),
          child: const Center(
              child: Text("start",
                  style: TextStyle(fontSize: 16, fontFamily: "Arcade"))),
        )
      ])),
    );
  }
}
