import 'package:flutter/material.dart';
import 'settings.dart';
import 'valorant/valorantPage.dart';
import 'minecraft/minecraftUser.dart';

//TODO: Need to stop duplication of objects

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepOrange, Colors.green],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 9,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.baby_changing_station_rounded,
                    size: 90,
                  ),
                ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ValorantPage()),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.baby_changing_station),
            title: const Row(
              children: [
                Text('Minecraft Api'),
                Expanded(child: SizedBox()),
                Icon(Icons.arrow_right_sharp),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MinecraftPage()),
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => MyHomePage()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Broken AF rn'),
                  duration: Duration(seconds: 2),
                ),
              );
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomizePage()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out'),
                  duration: Duration(seconds: 2),
                ),
              );
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
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => MyHomePage()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}