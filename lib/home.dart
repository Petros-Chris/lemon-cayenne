import 'package:flutter/material.dart';
import 'package:lemon_cayenne/game/main_menu.dart';
import 'drawer.dart';
import 'Theme/theme.dart';
import 'const.dart';
import 'valorant/valorant_page.dart';
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
    offset: const Offset(0, 3),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: const Text("The Lemon Project"),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              Text(
                "Hello $username, Where Would You Like To Go?",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              buildNavigationButton(
                context,
                'assets/Valorant.png',
                "Valorant Info",
                const ValorantPage(),
                120,
              ),
              const SizedBox(height: 20),
              buildNavigationButton(
                context,
                'assets/minecraftIcon.png',
                "Minecraft Skin Viewer",
                const MinecraftPage(),
                80,
              ),
              const SizedBox(height: 20),
              buildNavigationButton(
                context,
                'assets/aim.png',
                "Aim Game",
                const GameMenu(),
                120,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationButton(BuildContext context, String assetPath,
      String title, Widget page, double iconSize) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: MediaQuery.of(context).size.height - 610,
      decoration: BoxDecoration(
        boxShadow: [boxShadow],
        gradient: isDarkMode ? null : inputColor,
        color: isDarkMode ? const Color(0xFF3A3A3A) : null,
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: iconSize,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
