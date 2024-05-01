import 'package:flutter/material.dart';
import 'package:lemon_cayenne/game/startGame.dart';
import 'Drawer.dart';
import 'const.dart';
import 'valorant/valorantPage.dart';

import 'minecraft/minecraftUser.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: Text("The Lemon Project"),
        centerTitle: true,
      ),
      drawer: DrawerNav(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              Text("Hello $username, Where Would You Like To Go?"),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ValorantPage(),
                        ),
                      );
                    },
                    child: Text("Valorant")),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MinecraftPage(),
                        ),
                      );
                    },
                    child: Text("Minecraft")),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BeforeGamingPage(),
                        ),
                      );
                    },
                    child: Text("Training Game")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
