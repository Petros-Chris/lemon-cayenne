import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemon_cayenne/const.dart';
import 'dart:math';
import 'dart:async';
import 'package:lemon_cayenne/game/main_menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ClickTheSquare(),
    );
  }
}

class ClickTheSquare extends StatefulWidget {
  const ClickTheSquare({super.key});

  @override
  State<ClickTheSquare> createState() => _ClickTheSquareState();
}

class _ClickTheSquareState extends State<ClickTheSquare> {
  int score = 0;
  Timer? time;
  Timer? movementTime;
  int remainingSeconds = 10;
  double top = 100;
  double left = 100;

  void movement() {
    final random = Random();
      setState(() {
        score += 100;
        top = random.nextDouble() * (MediaQuery
            .of(context)
            .size
            .height - 180);
        left = random.nextDouble() * (MediaQuery
            .of(context)
            .size
            .width - 100);
      });
  }

  void startMovementTimer() {
    movementTime?.cancel();
    final random = Random();
    double time = 0;
    switch (difficulty) {
      case 'Easy': time = 10 * 1000; break;
      case 'Medium': time = 0.5 * 1000; break;
      case 'Hard': time = 0.2 * 1000; break;
      case 'Insane': time = 0.02 * 1000; break;
      default: time = 10 * 1000;
    }
    final duration = Duration(milliseconds: time.toInt());
    movementTime = Timer.periodic(duration, (timer) {
      setState(() {
        top = random.nextDouble() * (MediaQuery.of(context).size.height - 180);
        left = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
      });
    });
  }

  void startTimer() {
    time?.cancel();

    time = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          time?.cancel();
          movementTime?.cancel();
          checkAndUpdateHighScore();
          _showAlertDialog(context);
        }
      },
    );
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
      highestScore = 0;
      switch (difficulty) {
        case 'Easy': highestScore = userDoc['EasyScore']; break;
        case 'Medium': highestScore = userDoc['MediumScore']; break;
        case 'Hard': highestScore = userDoc['HardScore']; break;
        case 'Insane': highestScore = userDoc['InsaneScore']; break;
        default: highestScore = userDoc['EasyScore'];
      }

    }
  }

  Future<void> updateUser(String id, int newScore) async {
    String diff = "";
    switch (difficulty) {
      case 'Easy': diff = "Easy"; break;
      case 'Medium': diff = "Medium"; break;
      case 'Hard': diff = "Hard"; break;
      case 'Insane': diff = "Insane"; break;
      default: diff = "Easy";
    }
    await users.doc(id).update({'${diff}Score': newScore});
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
                        builder: (context) => const GameMenu()));
              },
              child: const Text('Return'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ClickTheSquare()));
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
    startMovementTimer();
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
                        builder: (context) => const GameMenu()));
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
              duration: const Duration(milliseconds: 0),
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
