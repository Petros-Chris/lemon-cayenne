import 'package:flutter/material.dart';
import 'package:lemon_cayenne/account/login.dart';
import 'package:lemon_cayenne/home.dart';
import 'Theme/theme.dart';
import 'game/main_menu.dart';
import 'settings.dart';
import 'valorant/valorantPage.dart';
import 'minecraft/minecraft_user.dart';

class DrawerNav extends StatefulWidget {
  const DrawerNav({super.key});

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: isDarkMode ? LinearGradient(begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x831100A9),
                  Color(0xFF251C1C),
                ],
              ) : inputColor,
            ),
            child: Column(
              children: [
                GestureDetector(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 50,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/lemon.png',
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Row(
              children: [
                Text('Valorant Api'),
                Expanded(child: SizedBox()),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ValorantPage()),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Image.asset('assets/minecraftIcon.png', width: 25,),
            title: const Row(
              children: [
                Text('Minecraft Api'),
                Expanded(child: SizedBox()),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MinecraftPage()),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Row(
              children: [
                Text('Game'),
                Expanded(child: SizedBox()),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => GameMenu()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Row(
              children: [
                Text('Customise'),
                Expanded(child: SizedBox()),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomizePage()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Row(
              children: [
                Text('Log Out'),
                Expanded(child: SizedBox()),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text('Logged out'),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
