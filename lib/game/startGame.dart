import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemon_cayenne/Drawer.dart';
import 'package:lemon_cayenne/const.dart';
import 'package:lemon_cayenne/game/testOfGame.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeforeGamingPage extends StatefulWidget {
  const BeforeGamingPage({super.key});

  @override
  State<BeforeGamingPage> createState() => _BeforeGamingPageState();
}

class _BeforeGamingPageState extends State<BeforeGamingPage> {
  int score = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> viewUser() async {
    QuerySnapshot querySnapshot =
        await users.where('Username', isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
        highestScore = userDoc['Score'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const DrawerNav(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(
                    "How To Play",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    "There will be red squares that will appear on your display, click them as fast as you can",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Text('Highest Score: $highestScore'),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Game()));
                },
                child: const Text("Play"),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
