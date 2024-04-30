import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemon_cayenne/const.dart';
import 'dart:math';
import 'dart:async';
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
      top = random.nextDouble() * (MediaQuery.of(context).size.height - 180);
      left = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
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

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> checkAndUpdateHighScore() async {
    await viewUser();
    if (score > highestScore) {
      await updateUser(username, score);
    }
  }

  Future<void> viewUser() async {
    QuerySnapshot querySnapshot =
        await users.where('Username', isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      highestScore = userDoc['Score'];
    }
  }

  Future<void> updateUser(String id, int newScore) async {
    await users.doc(id).update({'Score': newScore});
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
              top: top,
              left: left,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
