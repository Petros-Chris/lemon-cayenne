import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lemon_cayenne/game/startGame.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int score = 0;
  Timer? time;
  int remainingSeconds = 10;
  double top = 100;
  double left = 100;

  void movement() {
    final random = Random();
    setState(() {
      score += 100;
      top = random.nextDouble() * 300;
      left = random.nextDouble() * 300;
    });
  }

  void startTimer() {
    time?.cancel();

    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        time?.cancel();
        checkAndUpdateHighScore();
        _showAlertDialog(context);
      }
    });
  }

  Future<void> checkAndUpdateHighScore() async {
    int highestScore = await _loadScoreNumber();
    if (score > highestScore) {
      _saveScore();
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time Is Up!'),
          content: Text('Your Final Score Is $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeforeGamingPage()));
              },
              child: const Text('Return'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Game()));
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void _saveScore() async {
    // Get the SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Save the score
    prefs.setInt('score', score);
  }

  void _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      score = prefs.getInt('score') ?? 0;
    });
  }

  Future<int> _loadScoreNumber() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('score') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                time?.cancel();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeforeGamingPage()));
              },
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text(" Exit"),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Text("Time: $remainingSeconds"),
            const Expanded(child: SizedBox()),
            Text("Score: $score")
          ],
        ),
      ),
      body: GestureDetector(
        onTap: movement,
        child: Stack(
          children: [
            AnimatedPositioned(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
              top: top,
              left: left,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}
