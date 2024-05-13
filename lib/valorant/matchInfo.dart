import 'package:flutter/material.dart';

class MatchInfo extends StatelessWidget {
  final Map<String, dynamic> match;

  MatchInfo({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    // Directly accessing the red and blue teams from the match data
    List<dynamic> redTeam = match['players_red'];
    List<dynamic> blueTeam = match['players_blue'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Match Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMatchDetails(match),
            SizedBox(height: 10),
            Text('Red Team',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            buildPlayerList(redTeam),
            SizedBox(height: 10),
            Text('Blue Team',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            buildPlayerList(blueTeam),
          ],
        ),
      ),
    );
  }

  Widget buildMatchDetails(Map<String, dynamic> matchData) {
    return Column(
      children: [
        Text('Map: ${match['map']}', style: TextStyle(fontSize: 20)),
        Text('Mode: ${match['gameMode']}', style: TextStyle(fontSize: 20)),
        Text('Score: ${match['score']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildPlayerList(List<dynamic> team) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: team.length,
      itemBuilder: (context, index) {
        var player = team[index];
        String rankImagePath = getRankImagePath(player['currenttier_patched']);
        return Card(
          child: ListTile(
            title: Text('${player['name']}#${player['tag']}' , style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Row(
              children: [
                Text("Agent: "),
                Image.network(player['assets']['agent']['small'], // Agent icon
                  width: 30,
                  height: 30,),
                Text("- Rank: "),
                Image.asset(rankImagePath, width: 30, height: 30),
              ],
            ),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Kills: ${player['stats']['kills']}', style: TextStyle(fontSize: 12),),
                Text('Deaths: ${player['stats']['deaths']}', style: TextStyle(fontSize: 12),),
                Text('Assists: ${player['stats']['assists']}', style: TextStyle(fontSize: 12),),
              ],
            ),
          ),
        );
      },
    );
  }
}

String getRankImagePath(String rank) {
  // Handle the special case for "Radiant" rank
  if (rank.toLowerCase() == 'radiant') {
    return 'assets/Valorant_Images/Radiant_Rank.png'; // Ensure the file name is correct
  }
  else if(rank.toLowerCase() == 'unrated'){
    return 'assets/Valorant_Images/Unranked.png';
  }

  // Replace spaces with underscores and append '.png' for other ranks
  return 'assets/Valorant_Images/${rank.replaceAll(' ', '_')}_Rank.png';
}
