import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

enum CurrentTurn { blue, red }

class GameProvider extends ChangeNotifier {
  List<String> availableItems = ["knife", "cigar", "handcuff"];
  late Map<String, dynamic> activateItem;
  Map<String, int> healthInfo = {"blue": 5, "red": 5};
  Map<String, List<String>> inventory = {"blue": [], "red": []};
  List<bool> bulletsOrder = [];
  int lives = 0, blanks = 0;

  bool roundIntro = false;
  CurrentTurn currentTurn = CurrentTurn.blue;
  bool handcuffTurn = false;
  bool knifeTurn = false;

  String winner = "";

  GameProvider() {
    activateItem = {
      "knife": useKnifeItem,
      "cigar": useCigarItem,
      "handcuff": useHancuffItem,
    };
    nextRound();
  }

  nextRound() {
    generateNewLoad();
    generateNewBulletsOrder();
    giveRandomItems();
    playAudioAndDispose("assets/round.mp3");
    roundIntro = true;

    Future.delayed(3.5.seconds, () {
      roundIntro = false;
      gameEventNotifier();
    });

    gameEventNotifier();
  }

  selfShoot() {
    if (bulletsOrder.removeLast()) {
      playAudioAndDispose("assets/live.mp3");
      healthInfo[currentTurn.name] =
          healthInfo[currentTurn.name]! - (knifeTurn ? 2 : 1);
      if (!handcuffTurn) {
        currentTurn = currentTurn == CurrentTurn.blue
            ? CurrentTurn.red
            : CurrentTurn.blue;
      }
      handcuffTurn = false;
    } else {
      playAudioAndDispose("assets/blank.mp3");
    }

    knifeTurn = false;

    gameEventNotifier();
  }

  shootOpponent() {
    CurrentTurn target =
        currentTurn == CurrentTurn.blue ? CurrentTurn.red : CurrentTurn.blue;
    if (bulletsOrder.removeLast()) {
      playAudioAndDispose("assets/live.mp3");
      healthInfo[target.name] = healthInfo[target.name]! - (knifeTurn ? 2 : 1);
    } else {
      playAudioAndDispose("assets/blank.mp3");
    }

    if (!handcuffTurn) {
      currentTurn = target;
    }

    handcuffTurn = false;
    knifeTurn = false;

    gameEventNotifier();
  }

  // Item use functions

  useCigarItem() {
    healthInfo[currentTurn.name] != 5
        ? healthInfo[currentTurn.name] = healthInfo[currentTurn.name]! + 1
        : null;
    playAudioAndDispose("assets/cigar.mp3");
    gameEventNotifier();
  }

  useHancuffItem() {
    handcuffTurn = true;
    playAudioAndDispose("assets/handcuff.mp3");
    gameEventNotifier();
  }

  useKnifeItem() {
    knifeTurn = true;
    playAudioAndDispose("assets/knife.mp3");
    gameEventNotifier();
  }

  // Utils for the provider
  generateNewBulletsOrder() {
    bulletsOrder = List.filled(lives, true) + List.filled(blanks, false);
    bulletsOrder.shuffle();
  }

  generateNewLoad() {
    int total = Random().nextInt(7) + 2;
    lives = Random().nextInt(total) + 1;
    blanks = total - lives + 1;

    if (lives - blanks > 2) {
      lives--;
      blanks++;
    }
  }

  giveRandomItems() {
    int amount = Random().nextInt(5) + 1;
    inventory["red"]!
        .addAll(List.filled(amount, (availableItems..shuffle()).last));
    inventory["blue"]!
        .addAll(List.filled(amount, (availableItems..shuffle()).last));

    if (inventory["red"]!.length > 8) {
      inventory["red"] = inventory["red"]!.getRange(0, 8).toList();
    }
    if (inventory["blue"]!.length > 8) {
      inventory["blue"] = inventory["blue"]!.getRange(0, 8).toList();
    }
  }

  gameEventNotifier() {
    if (bulletsOrder.isEmpty) {
      nextRound();
      return;
    }

    if (healthInfo["blue"]! <= 0) {
      winner = "red";
      playAudioAndDispose("assets/win.mp3");
    }
    if (healthInfo["red"]! <= 0) {
      winner = "blue";
      playAudioAndDispose("assets/win.mp3");
    }

    notifyListeners();
  }

  // UI notifies provider
  updateRoudnIntro(bool v) {
    roundIntro = v;
    notifyListeners();
  }

  // Audio player
  playAudioAndDispose(String asset) {
    AudioPlayer player = AudioPlayer();
    player.setAsset(asset).then((_) async {
      await player.play();
      player.dispose();
    });
  }
}
