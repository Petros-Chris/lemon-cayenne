import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:lemon_cayenne/game/click_the_square.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  int score = 0;
  int highestScoreEasy = 0;
  int highestScoreMedium = 0;
  int highestScoreHard = 0;
  int highestScoreInsane = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> viewUser() async {
    QuerySnapshot querySnapshot =
    await users.where('Username', isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
        highestScoreEasy = userDoc['EasyScore'];
        highestScoreMedium = userDoc['MediumScore'];
        highestScoreHard = userDoc['HardScore'];
        highestScoreInsane = userDoc['InsaneScore'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    viewUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery
          .of(context)
          .size
          .width,
      appBar: AppBar(
        title: Text("Difficulty: $difficulty"),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(
                    "How To Play",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    "Click The blue Square",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Text('Highest Score On Easy: $highestScoreEasy'),
            Text('Highest Score On Medium: $highestScoreMedium'),
            Text('Highest Score On Hard: $highestScoreHard'),
            Text('Highest Score On Insane: $highestScoreInsane'),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const ClickTheSquare()));
                },
                child: const Text("Play"),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Text("Difficulty"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {
                  setState(() {
                    difficulty = "Easy";
                  });
                }, child: Text("Easy")),
                ElevatedButton(onPressed: () {
                  setState(() {
                    difficulty = "Medium";
                  });
                }, child: Text("Medium")),
                ElevatedButton(onPressed: () {
                  setState(() {
                    difficulty = "Hard";
                  });
                }, child: Text("Hard")),
                ElevatedButton(onPressed: () {
                  setState(() {
                    difficulty = "Insane";
                  });
                }, child: Text("Insane")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
