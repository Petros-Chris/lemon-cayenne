import 'package:flutter/material.dart';
import 'package:lemon_cayenne/game/main_menu.dart';
import 'Drawer.dart';
import 'Theme/theme.dart';
import 'const.dart';
import 'valorant/valorantPage.dart';

import 'minecraft/minecraft_user.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  var boxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 3),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery
          .of(context)
          .size
          .width,
      appBar: AppBar(
        title: const Text("The Lemon Project"),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              Text("Hello $username, Where Would You Like To Go?"),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                height: MediaQuery
                    .of(context)
                    .size
                    .width - 330,
                decoration: BoxDecoration(
                  boxShadow: [
                    boxShadow
                  ],
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ? const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ValorantPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "sweat with no life",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                height: MediaQuery
                    .of(context)
                    .size
                    .width - 330,
                decoration: BoxDecoration(
                  boxShadow: [
                    boxShadow
                  ],
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ? const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MinecraftPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/minecraftIcon.png',
                        width: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Visit Minecraft",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                height: MediaQuery
                    .of(context)
                    .size
                    .width - 330,
                decoration: BoxDecoration(
                  boxShadow: [
                    boxShadow
                  ],
                  gradient: isDarkMode ? null : inputColor,
                  color: isDarkMode ? const Color(0xFF3A3A3A) : null,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameMenu(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Click The Square rawr",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
