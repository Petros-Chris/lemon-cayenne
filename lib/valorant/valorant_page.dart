import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemon_cayenne/drawer.dart';
import 'dart:convert';
import '../Theme/theme.dart';
import 'match_info.dart';
import 'package:lemon_cayenne/valorant/weapon_page.dart';

const String apiKey = 'HDEV-6497b6fd-49e8-4e07-afcf-ac3beaaecb7d';
const String baseUrl = 'https://api.henrikdev.xyz/valorant/v3';
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
    Future<List<Map<String, dynamic>>> getMatches(
        String region, String name, String tag) async {
      var url = Uri.parse('$baseUrl/matches/$region/$name/$tag');
      var response = await http.get(url, headers: {'Authorization': apiKey});

      if (response.statusCode == 200) {
        _errorMessage = '';
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> matches = data['data'];
        List<Map<String, dynamic>> playerMatches = [];

        for (var match in matches) {
          List<dynamic> players = match['players']['all_players'];
          Map<String, dynamic>? player = players.firstWhere(
              (p) =>
                  p['name'].toLowerCase() == name.toLowerCase() &&
                  p['tag'].toLowerCase() == tag.toLowerCase(),
              orElse: () => null);

          if (player != null) {
            String agentIconUrl = player['assets']['agent']['small'];
            Map<String, dynamic> playerStats = {
              'matchId': match['metadata']['matchid'],
              'kills': player['stats']['kills'],
              'deaths': player['stats']['deaths'],
              'assists': player['stats']['assists'],
              'score':
                  '${match['teams']['red']['rounds_won']}-${match['teams']['blue']['rounds_won']}',
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
        return [];
      } else {
        _errorMessage = "${response.statusCode}";
        throw Exception(
            'Failed to load matches with status code: ${response.statusCode}');
      }
    }

    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        title: const Text("Player Info"),
        centerTitle: true,
      ),
      drawer: const DrawerNav(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: "Search For Username",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.tag),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 75,
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: "Tag",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty &&
                    _tagController.text.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isLoading = true;
                  });
                  getMatches(
                          'NA', _usernameController.text, _tagController.text)
                      .then((matches) {
                    setState(() {
                      infoMap = matches;
                      _isLoading = false;
                    });
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                "Search",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_errorMessage.isNotEmpty)
                    Center(child: Text(_errorMessage))
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: infoMap.length,
                      itemBuilder: (context, index) {
                        var match = infoMap[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchInfo(match: match),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(10),
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      match['characterIconSmall'],
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Map: ${match['map']}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Game Mode: ${match['gameMode']}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeaponPage()),
        );
    }
  }
}

void main() => runApp(const MaterialApp(home: ValorantPage()));
