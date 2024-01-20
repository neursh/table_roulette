import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_roulette/screens/home.dart';

void main() {
  runApp(const TableRoulette());
}

class TableRoulette extends StatelessWidget {
  const TableRoulette({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp(
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.black,
            useMaterial3: true),
        themeMode: ThemeMode.dark,
        home: const BaseLayer());
  }
}

class BaseLayer extends StatelessWidget {
  const BaseLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
