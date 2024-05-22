import 'package:flutter/material.dart';

class MatchInfo extends StatelessWidget {
  final Map<String, dynamic> match;

  const MatchInfo({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    List<dynamic> redTeam = match['players_red'];
    List<dynamic> blueTeam = match['players_blue'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Match Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMatchDetails(match),
            const SizedBox(height: 10),
            const Text(
              'Red Team',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            buildPlayerList(redTeam),
            const SizedBox(height: 10),
            const Text(
              'Blue Team',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            buildPlayerList(blueTeam),
          ],
        ),
      ),
    );
  }

  Widget buildMatchDetails(Map<String, dynamic> matchData) {
    return Column(
      children: [
        Text('Map: ${match['map']}', style: const TextStyle(fontSize: 20)),
        Text('Mode: ${match['gameMode']}',
            style: const TextStyle(fontSize: 20)),
        Text('Score: ${match['score']}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildPlayerList(List<dynamic> team) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: team.length,
      itemBuilder: (context, index) {
        var player = team[index];
        String rankImagePath = getRankImagePath(player['currenttier_patched']);
        return Card(
          child: ListTile(
            title: Text(
              '${player['name']}#${player['tag']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Text("Agent: "),
                Image.network(
                  player['assets']['agent']['small'],
                  width: 30,
                  height: 30,
                ),
                const Text("- Rank: "),
                Image.asset(rankImagePath, width: 30, height: 30),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Kills: ${player['stats']['kills']}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Deaths: ${player['stats']['deaths']}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Assists: ${player['stats']['assists']}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String getRankImagePath(String rank) {
  if (rank.toLowerCase() == 'radiant') {
    return 'assets/Valorant_Images/Radiant_Rank.png';
  } else if (rank.toLowerCase() == 'unrated') {
    return 'assets/Valorant_Images/Unranked.png';
  }
  return 'assets/Valorant_Images/${rank.replaceAll(' ', '_')}_Rank.png';
}
