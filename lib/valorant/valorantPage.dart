import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/Drawer.dart';
import 'dart:convert';
import 'matchInfo.dart';

import 'package:lemon_cayenne/valorant/weaponPage.dart';


final String apiKey = 'Your_API_Key';
final String baseUrl = 'https://api.henrikdev.xyz/valorant/v3';
bool _isLoading = false;
String _errorMessage = '';


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
        _errorMessage = '';
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> matches = data['data'];
        List<Map<String, dynamic>> playerMatches = [];

        for (var match in matches) {
          List<dynamic> players = match['players']['all_players'];
          Map<String, dynamic>? player = players.firstWhere(
                  (p) => p['name'].toLowerCase() == name.toLowerCase() && p['tag'].toLowerCase() == tag.toLowerCase(),
              orElse: () => null
          );

          if (player != null) {
            String agentIconUrl = player['assets']['agent']['small'];
            Map<String, dynamic> playerStats = {
              'matchId': match['metadata']['matchid'],
              'kills': player['stats']['kills'],
              'deaths': player['stats']['deaths'],
              'assists': player['stats']['assists'],
              'score': '${match['teams']['red']['rounds_won']}-${match['teams']['blue']['rounds_won']}',
              'map': match['metadata']['map'],
              'gameMode': match['metadata']['mode'],
              'characterIconSmall': agentIconUrl,
              'players_red': match['players']['red'],
              'players_blue': match['players']['blue'],
            };
            playerMatches.add(playerStats);
          }
        }

        if (playerMatches.isEmpty) {
          _errorMessage = "No matches found for the player.";
        }

        return playerMatches;
      } else if (response.statusCode == 404) {
        _errorMessage = "Player not found.";
        return []; // Return an empty list when no player is found
      } else {
        _errorMessage = "${response.statusCode}";
        throw Exception('Failed to load matches with status code: ${response.statusCode}');

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
      body: SingleChildScrollView(
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
                onPressed: () {
                  if (_usernameController.text.isNotEmpty && _tagController.text.isNotEmpty) {
                    FocusScope.of(context).unfocus();
                    setState(() { _isLoading = true; });
                    getMatches('NA', _usernameController.text, _tagController.text).then((matches) {
                      setState(() {
                        infoMap = matches;
                        _isLoading = false;
                      });
                    });
                  }
                },
                child: Text("Search")
            ),




            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(child: Text(_errorMessage)) // Display this message if no player data was found
            else
              Container(
                width: 500,
                height: 530,
                child: ListView.builder(
                  itemCount: infoMap.length,
                  itemBuilder: (context, index) {
                    var match = infoMap[index]; // Get current match data
                    return InkWell(  // Using InkWell for visual feedback on tap
                      onTap: () {
                        print('Navigating to MatchInfo with data: $match');
                        // Future.delayed(Duration(seconds: 5),
                        //
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MatchInfo(match: match)),
                        );

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  match['characterIconSmall'], // Agent icon
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(width: 50),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Map: ${match['map']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      Text('Game Mode: ${match['gameMode']}', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Kills: ${match['kills']}'),
                                Text('Deaths: ${match['deaths']}'),
                                Text('Assists: ${match['assists']}'),
                                Text('Score: ${match['score']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
