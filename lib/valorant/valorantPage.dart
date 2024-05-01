import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/Drawer.dart';
import 'dart:convert';
import 'matchInfo.dart';

import 'package:lemon_cayenne/valorant/weaponPage.dart';


final String apiKey = 'Your_API_Key';
final String baseUrl = 'https://api.henrikdev.xyz/valorant/v3';

class ValorantPage extends StatefulWidget {
  const ValorantPage({super.key});

  @override
  State<ValorantPage> createState() => ValorantPageState();
}

class ValorantPageState extends State<ValorantPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  int _selectedIndex = 0;
  List<Map<String, dynamic>> infoMap = [];
  var decodedResponse;
  bool flag = false;


  @override
  Widget build(BuildContext context) {

    Future<List<Map<String, dynamic>>> getMatches(String region, String name, String tag) async {
      var url = Uri.parse('$baseUrl/matches/$region/$name/$tag');
      var response = await http.get(url, headers: {'X-API-Key': apiKey});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> matches = data['data'];
        List<Map<String, dynamic>> playerMatches = [];

        for (var match in matches) {
          // Locate player stats within the 'players -> all_players' list
          Map<String, dynamic>? player = match['players']['all_players']
              .firstWhere((p) => p['name'].toLowerCase() == name.toLowerCase() && p['tag'].toLowerCase() == tag.toLowerCase(), orElse: () => null);

          if (player != null) {
            // Now that you have the specific player, extract their stats
            Map<String, dynamic> playerStats = {
              'matchId': match['metadata']['matchid'],
              'kills': player['stats']['kills'],
              'deaths': player['stats']['deaths'],
              'assists': player['stats']['assists'],
              'score': '${match['teams']['red']['score']}-${match['teams']['blue']['score']}',
              // Add other details you want to extract
            };
            // Get match score if needed, assuming 'red' and 'blue' are teams


            playerMatches.add(playerStats);
          }
        }
        return playerMatches;
      } else {
        throw Exception('Failed to load matches');
      }
    }
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: Text(
          "Player Info", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),

      ),
      drawer: DrawerNav(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                hintText: "Search For Username",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 75,
                          child: TextField(
                            controller: _tagController,
                            decoration: InputDecoration(
                                hintText: "Tag",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),

                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  infoMap = await getMatches('NA', _usernameController.text, _tagController.text);
                  flag = true;

                },
                child: Text("Search")),

              Container(
                width: 500,
                height: 200,
                child: ListView.builder(
                    itemCount: infoMap.length,
                    // Ensure you have the correct item count
                    itemBuilder: (context, index) {
                      var match = infoMap[index]; // Get current match data
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                           //Text('Match ID: ${match['matchId']}'),
                            // Display Match ID
                            Text('Kills: ${match['kills']}'),
                            // Display Kills
                            Text('Deaths: ${match['deaths']}'),
                            // Display Deaths
                            Text('Assists: ${match['assists']}'),
                            // Display Assists
                            Text('Score: ${match['score']}'),
                            // Display Score
                          ],
                        ),
                      );
                    }
                ),


              ),



          ],
        ),

      ),





      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Player Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode_fan_off_outlined),
            label: 'Weapon Data',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WeaponPage()),
        );
    }
  }
}
//yes
