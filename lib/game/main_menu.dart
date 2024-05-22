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
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: Text("Difficulty: $difficulty"),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 40),
            Text(
              'Highest Score On Easy: $highestScoreEasy',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Highest Score On Medium: $highestScoreMedium',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Highest Score On Hard: $highestScoreHard',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Highest Score On Insane: $highestScoreInsane',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 40),
            const Text("Difficulty", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          difficulty = "Easy";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      child: const Text("Easy"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          difficulty = "Medium";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      child: const Text("Medium"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          difficulty = "Hard";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      child: const Text("Hard"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          difficulty = "Insane";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      child: const Text("Insane"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
